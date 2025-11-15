#!/bin/bash
set -e

# Database setup script for CI environments
# This script ensures database is properly initialized with all migrations

echo "🔧 Setting up test database..."

# Export database URLs
export DATABASE_URL="${DATABASE_URL:-postgresql://postgres:postgres@localhost:5432/test_db}"
export DIRECT_DATABASE_URL="${DIRECT_DATABASE_URL:-$DATABASE_URL}"

echo "📊 Database URL: ${DATABASE_URL}"

# Generate Prisma client
echo "🔧 Generating Prisma client..."
bunx prisma generate

# Use prisma migrate reset which properly handles schema recreation
echo "🗄️ Resetting database and applying all migrations..."
if [ "$SKIP_SEED" == "true" ]; then
  bunx prisma migrate reset --force --skip-seed --skip-generate
else
  bunx prisma migrate reset --force --skip-generate
fi

# Verify critical tables exist
echo "🔍 Verifying database tables..."
bunx prisma db execute --url="$DATABASE_URL" --stdin <<EOF
SELECT tablename FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN ('User', 'Post', 'Comment', 'Actor', 'Pool', 'Question')
ORDER BY tablename;
EOF

# Count tables to ensure migration succeeded
TABLE_COUNT=$(bunx prisma db execute --url="$DATABASE_URL" --stdin <<< "SELECT COUNT(*) FROM pg_tables WHERE schemaname = 'public';" | grep -oE '[0-9]+' | tail -1)
echo "✅ Found $TABLE_COUNT tables in database"

if [ "$TABLE_COUNT" -lt "70" ]; then
  echo "❌ ERROR: Expected at least 70 tables but found only $TABLE_COUNT"
  echo "Migration may have failed. Checking migration status..."
  bunx prisma migrate status

  # Check specifically for the Question table
  QUESTION_EXISTS=$(bunx prisma db execute --url="$DATABASE_URL" --stdin <<< "SELECT COUNT(*) FROM pg_tables WHERE schemaname = 'public' AND tablename = 'Question';" | grep -oE '[0-9]+' | tail -1)
  if [ "$QUESTION_EXISTS" -eq "0" ]; then
    echo "❌ CRITICAL: Question table does not exist!"
  fi
  exit 1
fi

# Run seed if not skipped
if [ "$SKIP_SEED" != "true" ]; then
  echo "🌱 Seeding database..."
  bunx prisma db seed
fi

echo "✅ Database setup complete!"