-- AlterTable
ALTER TABLE "Post" ADD COLUMN     "deletedAt" TIMESTAMP(3);

-- CreateIndex
CREATE INDEX "Post_deletedAt_idx" ON "Post"("deletedAt");
