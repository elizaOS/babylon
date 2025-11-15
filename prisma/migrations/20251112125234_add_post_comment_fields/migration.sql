-- AlterTable
ALTER TABLE "Comment" ADD COLUMN     "deletedAt" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "PerpPosition" ADD COLUMN     "settledAt" TIMESTAMP(3),
ADD COLUMN     "settledToChain" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "settlementTxHash" TEXT;

-- AlterTable
ALTER TABLE "Post" ADD COLUMN     "commentOnPostId" TEXT,
ADD COLUMN     "parentCommentId" TEXT;

-- CreateTable
CREATE TABLE "UserGroup" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "createdById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserGroupMember" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "addedBy" TEXT NOT NULL,

    CONSTRAINT "UserGroupMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserGroupAdmin" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "grantedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "grantedBy" TEXT NOT NULL,

    CONSTRAINT "UserGroupAdmin_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserGroupInvite" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "invitedUserId" TEXT NOT NULL,
    "invitedBy" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "invitedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "respondedAt" TIMESTAMP(3),
    "message" TEXT,

    CONSTRAINT "UserGroupInvite_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "UserGroup_createdById_idx" ON "UserGroup"("createdById");

-- CreateIndex
CREATE INDEX "UserGroup_createdAt_idx" ON "UserGroup"("createdAt" DESC);

-- CreateIndex
CREATE INDEX "UserGroupMember_groupId_idx" ON "UserGroupMember"("groupId");

-- CreateIndex
CREATE INDEX "UserGroupMember_userId_idx" ON "UserGroupMember"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "UserGroupMember_groupId_userId_key" ON "UserGroupMember"("groupId", "userId");

-- CreateIndex
CREATE INDEX "UserGroupAdmin_groupId_idx" ON "UserGroupAdmin"("groupId");

-- CreateIndex
CREATE INDEX "UserGroupAdmin_userId_idx" ON "UserGroupAdmin"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "UserGroupAdmin_groupId_userId_key" ON "UserGroupAdmin"("groupId", "userId");

-- CreateIndex
CREATE INDEX "UserGroupInvite_groupId_idx" ON "UserGroupInvite"("groupId");

-- CreateIndex
CREATE INDEX "UserGroupInvite_invitedUserId_status_idx" ON "UserGroupInvite"("invitedUserId", "status");

-- CreateIndex
CREATE INDEX "UserGroupInvite_status_idx" ON "UserGroupInvite"("status");

-- CreateIndex
CREATE UNIQUE INDEX "UserGroupInvite_groupId_invitedUserId_key" ON "UserGroupInvite"("groupId", "invitedUserId");

-- CreateIndex
CREATE INDEX "Comment_deletedAt_idx" ON "Comment"("deletedAt");

-- CreateIndex
CREATE INDEX "Comment_postId_deletedAt_idx" ON "Comment"("postId", "deletedAt");

-- CreateIndex
CREATE INDEX "Notification_userId_type_read_idx" ON "Notification"("userId", "type", "read");

-- CreateIndex
CREATE INDEX "PerpPosition_settledToChain_idx" ON "PerpPosition"("settledToChain");

-- CreateIndex
CREATE INDEX "Post_commentOnPostId_idx" ON "Post"("commentOnPostId");

-- CreateIndex
CREATE INDEX "Post_parentCommentId_idx" ON "Post"("parentCommentId");

-- CreateIndex
CREATE INDEX "Post_type_deletedAt_timestamp_idx" ON "Post"("type", "deletedAt", "timestamp" DESC);

-- CreateIndex
CREATE INDEX "Post_authorId_type_timestamp_idx" ON "Post"("authorId", "type", "timestamp" DESC);

-- CreateIndex
CREATE INDEX "User_displayName_idx" ON "User"("displayName");

-- CreateIndex
CREATE INDEX "User_isBanned_isActor_idx" ON "User"("isBanned", "isActor");

-- CreateIndex
CREATE INDEX "User_profileComplete_createdAt_idx" ON "User"("profileComplete", "createdAt" DESC);

-- AddForeignKey
ALTER TABLE "UserGroupMember" ADD CONSTRAINT "UserGroupMember_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "UserGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserGroupAdmin" ADD CONSTRAINT "UserGroupAdmin_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "UserGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_commentOnPostId_fkey" FOREIGN KEY ("commentOnPostId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_parentCommentId_fkey" FOREIGN KEY ("parentCommentId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;
