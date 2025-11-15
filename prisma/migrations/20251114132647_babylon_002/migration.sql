/*
  Warnings:

  - A unique constraint covering the columns `[oracleSessionId]` on the table `Question` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Actor" ADD COLUMN     "isTest" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Chat" ADD COLUMN     "groupId" TEXT;

-- AlterTable
ALTER TABLE "Market" ADD COLUMN     "onChainMarketId" TEXT,
ADD COLUMN     "onChainResolutionTxHash" TEXT,
ADD COLUMN     "onChainResolved" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "oracleAddress" TEXT;

-- AlterTable
ALTER TABLE "Notification" ADD COLUMN     "groupId" TEXT,
ADD COLUMN     "inviteId" TEXT;

-- AlterTable
ALTER TABLE "Post" ADD COLUMN     "originalPostId" TEXT;

-- AlterTable
ALTER TABLE "Question" ADD COLUMN     "oracleCommitBlock" INTEGER,
ADD COLUMN     "oracleCommitTxHash" TEXT,
ADD COLUMN     "oracleCommitment" TEXT,
ADD COLUMN     "oracleError" TEXT,
ADD COLUMN     "oraclePublishedAt" TIMESTAMP(3),
ADD COLUMN     "oracleRevealBlock" INTEGER,
ADD COLUMN     "oracleRevealTxHash" TEXT,
ADD COLUMN     "oracleSaltEncrypted" TEXT,
ADD COLUMN     "oracleSessionId" TEXT;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "agentConstraints" JSONB,
ADD COLUMN     "agentCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "agentDirectives" JSONB,
ADD COLUMN     "agentErrorMessage" TEXT,
ADD COLUMN     "agentGoals" JSONB,
ADD COLUMN     "agentLastChatAt" TIMESTAMP(3),
ADD COLUMN     "agentLastTickAt" TIMESTAMP(3),
ADD COLUMN     "agentMaxActionsPerTick" INTEGER NOT NULL DEFAULT 3,
ADD COLUMN     "agentMessageExamples" JSONB,
ADD COLUMN     "agentModelTier" TEXT NOT NULL DEFAULT 'free',
ADD COLUMN     "agentPersonaPrompt" TEXT,
ADD COLUMN     "agentPersonality" TEXT,
ADD COLUMN     "agentPlanningHorizon" TEXT NOT NULL DEFAULT 'single',
ADD COLUMN     "agentPointsBalance" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "agentRiskTolerance" TEXT NOT NULL DEFAULT 'medium',
ADD COLUMN     "agentStatus" TEXT NOT NULL DEFAULT 'idle',
ADD COLUMN     "agentStyle" JSONB,
ADD COLUMN     "agentSystem" TEXT,
ADD COLUMN     "agentTotalDeposited" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "agentTotalPointsSpent" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "agentTotalWithdrawn" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "agentTradingStrategy" TEXT,
ADD COLUMN     "autonomousCommenting" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "autonomousDMs" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "autonomousGroupChats" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "autonomousPosting" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "autonomousTrading" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "isAgent" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "isTest" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "managedBy" TEXT,
ADD COLUMN     "totalAgentPnL" DECIMAL(18,2) NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "AgentLog" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "level" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "prompt" TEXT,
    "completion" TEXT,
    "thinking" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "agentUserId" TEXT NOT NULL,

    CONSTRAINT "AgentLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AgentMessage" (
    "id" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "modelUsed" TEXT,
    "pointsCost" INTEGER NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "agentUserId" TEXT NOT NULL,

    CONSTRAINT "AgentMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AgentGoal" (
    "id" TEXT NOT NULL,
    "agentUserId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "target" JSONB,
    "priority" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "progress" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "AgentGoal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AgentGoalAction" (
    "id" TEXT NOT NULL,
    "goalId" TEXT NOT NULL,
    "agentUserId" TEXT NOT NULL,
    "actionType" TEXT NOT NULL,
    "actionId" TEXT,
    "impact" DOUBLE PRECISION NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AgentGoalAction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AgentPointsTransaction" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "balanceBefore" INTEGER NOT NULL,
    "balanceAfter" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    "relatedId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "agentUserId" TEXT NOT NULL,
    "managerUserId" TEXT NOT NULL,

    CONSTRAINT "AgentPointsTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AgentTrade" (
    "id" TEXT NOT NULL,
    "marketType" TEXT NOT NULL,
    "marketId" TEXT,
    "ticker" TEXT,
    "action" TEXT NOT NULL,
    "side" TEXT,
    "amount" DOUBLE PRECISION NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "pnl" DOUBLE PRECISION,
    "reasoning" TEXT,
    "executedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "agentUserId" TEXT NOT NULL,

    CONSTRAINT "AgentTrade_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DMAcceptance" (
    "id" TEXT NOT NULL,
    "chatId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "otherUserId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "acceptedAt" TIMESTAMP(3),
    "rejectedAt" TIMESTAMP(3),

    CONSTRAINT "DMAcceptance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OAuthState" (
    "id" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "codeVerifier" TEXT NOT NULL,
    "userId" TEXT,
    "returnPath" TEXT,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OAuthState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OracleCommitment" (
    "id" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "saltEncrypted" TEXT NOT NULL,
    "commitment" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OracleCommitment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OracleTransaction" (
    "id" TEXT NOT NULL,
    "questionId" TEXT,
    "txType" TEXT NOT NULL,
    "txHash" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "blockNumber" INTEGER,
    "gasUsed" BIGINT,
    "gasPrice" BIGINT,
    "error" TEXT,
    "retryCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "confirmedAt" TIMESTAMP(3),

    CONSTRAINT "OracleTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProfileUpdateLog" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "changedFields" TEXT[],
    "backendSigned" BOOLEAN NOT NULL,
    "txHash" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProfileUpdateLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TwitterOAuthToken" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "oauth1Token" TEXT NOT NULL,
    "oauth1TokenSecret" TEXT NOT NULL,
    "screenName" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TwitterOAuthToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "llm_call_logs" (
    "id" TEXT NOT NULL,
    "trajectoryId" TEXT NOT NULL,
    "stepId" TEXT NOT NULL,
    "callId" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "latencyMs" INTEGER,
    "model" TEXT NOT NULL,
    "purpose" TEXT NOT NULL,
    "actionType" TEXT,
    "systemPrompt" TEXT NOT NULL,
    "userPrompt" TEXT NOT NULL,
    "messagesJson" TEXT,
    "response" TEXT NOT NULL,
    "reasoning" TEXT,
    "temperature" DOUBLE PRECISION NOT NULL,
    "maxTokens" INTEGER NOT NULL,
    "topP" DOUBLE PRECISION,
    "promptTokens" INTEGER,
    "completionTokens" INTEGER,
    "totalTokens" INTEGER,
    "metadata" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "llm_call_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "market_outcomes" (
    "id" TEXT NOT NULL,
    "windowId" VARCHAR(50) NOT NULL,
    "stockTicker" VARCHAR(20),
    "startPrice" DECIMAL(10,2),
    "endPrice" DECIMAL(10,2),
    "changePercent" DECIMAL(5,2),
    "sentiment" VARCHAR(20),
    "newsEvents" JSONB,
    "predictionMarketId" TEXT,
    "question" TEXT,
    "outcome" VARCHAR(20),
    "finalProbability" DECIMAL(5,4),
    "volume" DECIMAL(15,2),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "market_outcomes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trained_models" (
    "id" TEXT NOT NULL,
    "modelId" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "baseModel" TEXT NOT NULL,
    "trainingBatch" TEXT,
    "status" TEXT NOT NULL DEFAULT 'training',
    "deployedAt" TIMESTAMP(3),
    "archivedAt" TIMESTAMP(3),
    "storagePath" TEXT NOT NULL,
    "benchmarkScore" DOUBLE PRECISION,
    "accuracy" DOUBLE PRECISION,
    "avgReward" DOUBLE PRECISION,
    "evalMetrics" JSONB,
    "wandbRunId" TEXT,
    "wandbArtifactId" TEXT,
    "agentsUsing" INTEGER NOT NULL DEFAULT 0,
    "totalInferences" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "trained_models_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "training_batches" (
    "id" TEXT NOT NULL,
    "batchId" TEXT NOT NULL,
    "scenarioId" TEXT,
    "baseModel" TEXT NOT NULL,
    "modelVersion" TEXT NOT NULL,
    "trajectoryIds" TEXT NOT NULL,
    "rankingsJson" TEXT,
    "rewardsJson" TEXT NOT NULL,
    "trainingLoss" DOUBLE PRECISION,
    "policyImprovement" DOUBLE PRECISION,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "error" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "startedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "training_batches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trajectories" (
    "id" TEXT NOT NULL,
    "trajectoryId" TEXT NOT NULL,
    "agentId" TEXT NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3) NOT NULL,
    "durationMs" INTEGER NOT NULL,
    "windowId" VARCHAR(50),
    "windowHours" INTEGER NOT NULL DEFAULT 1,
    "episodeId" VARCHAR(100),
    "scenarioId" VARCHAR(100),
    "batchId" VARCHAR(100),
    "stepsJson" TEXT NOT NULL,
    "rewardComponentsJson" TEXT NOT NULL,
    "metricsJson" TEXT NOT NULL,
    "metadataJson" TEXT NOT NULL,
    "totalReward" DOUBLE PRECISION NOT NULL,
    "episodeLength" INTEGER NOT NULL,
    "finalStatus" TEXT NOT NULL,
    "finalBalance" DOUBLE PRECISION,
    "finalPnL" DOUBLE PRECISION,
    "tradesExecuted" INTEGER,
    "postsCreated" INTEGER,
    "aiJudgeReward" DOUBLE PRECISION,
    "aiJudgeReasoning" TEXT,
    "judgedAt" TIMESTAMP(3),
    "isTrainingData" BOOLEAN NOT NULL DEFAULT true,
    "isEvaluation" BOOLEAN NOT NULL DEFAULT false,
    "usedInTraining" BOOLEAN NOT NULL DEFAULT false,
    "trainedInBatch" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "trajectories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reward_judgments" (
    "id" TEXT NOT NULL,
    "trajectoryId" TEXT NOT NULL,
    "judgeModel" TEXT NOT NULL,
    "judgeVersion" TEXT NOT NULL,
    "overallScore" DOUBLE PRECISION NOT NULL,
    "componentScoresJson" TEXT,
    "rank" INTEGER,
    "normalizedScore" DOUBLE PRECISION,
    "groupId" TEXT,
    "reasoning" TEXT NOT NULL,
    "strengthsJson" TEXT,
    "weaknessesJson" TEXT,
    "criteriaJson" TEXT NOT NULL,
    "judgedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reward_judgments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserBlock" (
    "id" TEXT NOT NULL,
    "blockerId" TEXT NOT NULL,
    "blockedId" TEXT NOT NULL,
    "reason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserBlock_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserMute" (
    "id" TEXT NOT NULL,
    "muterId" TEXT NOT NULL,
    "mutedId" TEXT NOT NULL,
    "reason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserMute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Report" (
    "id" TEXT NOT NULL,
    "reporterId" TEXT NOT NULL,
    "reportedUserId" TEXT,
    "reportedPostId" TEXT,
    "reportType" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "evidence" TEXT,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "priority" TEXT NOT NULL DEFAULT 'normal',
    "resolution" TEXT,
    "resolvedBy" TEXT,
    "resolvedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Report_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SystemSettings" (
    "id" TEXT NOT NULL DEFAULT 'system',
    "wandbModel" TEXT,
    "wandbEnabled" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SystemSettings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorldFact" (
    "id" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "source" TEXT,
    "lastUpdated" TIMESTAMP(3) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "WorldFact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RSSFeedSource" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "feedUrl" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastFetched" TIMESTAMP(3),
    "fetchErrors" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RSSFeedSource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RSSHeadline" (
    "id" TEXT NOT NULL,
    "sourceId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "link" TEXT,
    "publishedAt" TIMESTAMP(3) NOT NULL,
    "summary" TEXT,
    "content" TEXT,
    "rawData" JSONB,
    "fetchedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RSSHeadline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ParodyHeadline" (
    "id" TEXT NOT NULL,
    "originalHeadlineId" TEXT NOT NULL,
    "originalTitle" TEXT NOT NULL,
    "originalSource" TEXT NOT NULL,
    "parodyTitle" TEXT NOT NULL,
    "parodyContent" TEXT,
    "characterMappings" JSONB NOT NULL,
    "organizationMappings" JSONB NOT NULL,
    "generatedAt" TIMESTAMP(3) NOT NULL,
    "isUsed" BOOLEAN NOT NULL DEFAULT false,
    "usedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ParodyHeadline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CharacterMapping" (
    "id" TEXT NOT NULL,
    "realName" TEXT NOT NULL,
    "parodyName" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "aliases" TEXT[],
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CharacterMapping_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationMapping" (
    "id" TEXT NOT NULL,
    "realName" TEXT NOT NULL,
    "parodyName" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "aliases" TEXT[],
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "OrganizationMapping_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "AgentLog_agentUserId_createdAt_idx" ON "AgentLog"("agentUserId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "AgentLog_level_idx" ON "AgentLog"("level");

-- CreateIndex
CREATE INDEX "AgentLog_type_createdAt_idx" ON "AgentLog"("type", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "AgentMessage_agentUserId_createdAt_idx" ON "AgentMessage"("agentUserId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "AgentMessage_role_idx" ON "AgentMessage"("role");

-- CreateIndex
CREATE INDEX "AgentGoal_agentUserId_status_idx" ON "AgentGoal"("agentUserId", "status");

-- CreateIndex
CREATE INDEX "AgentGoal_priority_idx" ON "AgentGoal"("priority" DESC);

-- CreateIndex
CREATE INDEX "AgentGoal_status_idx" ON "AgentGoal"("status");

-- CreateIndex
CREATE INDEX "AgentGoal_createdAt_idx" ON "AgentGoal"("createdAt" DESC);

-- CreateIndex
CREATE INDEX "AgentGoalAction_goalId_idx" ON "AgentGoalAction"("goalId");

-- CreateIndex
CREATE INDEX "AgentGoalAction_agentUserId_createdAt_idx" ON "AgentGoalAction"("agentUserId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "AgentGoalAction_actionType_idx" ON "AgentGoalAction"("actionType");

-- CreateIndex
CREATE INDEX "AgentPointsTransaction_agentUserId_createdAt_idx" ON "AgentPointsTransaction"("agentUserId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "AgentPointsTransaction_managerUserId_createdAt_idx" ON "AgentPointsTransaction"("managerUserId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "AgentPointsTransaction_type_idx" ON "AgentPointsTransaction"("type");

-- CreateIndex
CREATE INDEX "AgentTrade_agentUserId_executedAt_idx" ON "AgentTrade"("agentUserId", "executedAt" DESC);

-- CreateIndex
CREATE INDEX "AgentTrade_marketType_marketId_idx" ON "AgentTrade"("marketType", "marketId");

-- CreateIndex
CREATE INDEX "AgentTrade_ticker_idx" ON "AgentTrade"("ticker");

-- CreateIndex
CREATE UNIQUE INDEX "DMAcceptance_chatId_key" ON "DMAcceptance"("chatId");

-- CreateIndex
CREATE INDEX "DMAcceptance_status_createdAt_idx" ON "DMAcceptance"("status", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "DMAcceptance_userId_status_idx" ON "DMAcceptance"("userId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "OAuthState_state_key" ON "OAuthState"("state");

-- CreateIndex
CREATE INDEX "OAuthState_expiresAt_idx" ON "OAuthState"("expiresAt");

-- CreateIndex
CREATE INDEX "OAuthState_state_idx" ON "OAuthState"("state");

-- CreateIndex
CREATE UNIQUE INDEX "OracleCommitment_questionId_key" ON "OracleCommitment"("questionId");

-- CreateIndex
CREATE INDEX "OracleCommitment_createdAt_idx" ON "OracleCommitment"("createdAt");

-- CreateIndex
CREATE INDEX "OracleCommitment_questionId_idx" ON "OracleCommitment"("questionId");

-- CreateIndex
CREATE INDEX "OracleCommitment_sessionId_idx" ON "OracleCommitment"("sessionId");

-- CreateIndex
CREATE UNIQUE INDEX "OracleTransaction_txHash_key" ON "OracleTransaction"("txHash");

-- CreateIndex
CREATE INDEX "OracleTransaction_questionId_idx" ON "OracleTransaction"("questionId");

-- CreateIndex
CREATE INDEX "OracleTransaction_status_createdAt_idx" ON "OracleTransaction"("status", "createdAt");

-- CreateIndex
CREATE INDEX "OracleTransaction_txHash_idx" ON "OracleTransaction"("txHash");

-- CreateIndex
CREATE INDEX "OracleTransaction_txType_idx" ON "OracleTransaction"("txType");

-- CreateIndex
CREATE INDEX "ProfileUpdateLog_userId_createdAt_idx" ON "ProfileUpdateLog"("userId", "createdAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "TwitterOAuthToken_userId_key" ON "TwitterOAuthToken"("userId");

-- CreateIndex
CREATE INDEX "TwitterOAuthToken_userId_idx" ON "TwitterOAuthToken"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "llm_call_logs_callId_key" ON "llm_call_logs"("callId");

-- CreateIndex
CREATE INDEX "llm_call_logs_callId_idx" ON "llm_call_logs"("callId");

-- CreateIndex
CREATE INDEX "llm_call_logs_timestamp_idx" ON "llm_call_logs"("timestamp");

-- CreateIndex
CREATE INDEX "llm_call_logs_trajectoryId_idx" ON "llm_call_logs"("trajectoryId");

-- CreateIndex
CREATE INDEX "market_outcomes_windowId_idx" ON "market_outcomes"("windowId");

-- CreateIndex
CREATE INDEX "market_outcomes_windowId_stockTicker_idx" ON "market_outcomes"("windowId", "stockTicker");

-- CreateIndex
CREATE UNIQUE INDEX "trained_models_modelId_key" ON "trained_models"("modelId");

-- CreateIndex
CREATE INDEX "trained_models_status_idx" ON "trained_models"("status");

-- CreateIndex
CREATE INDEX "trained_models_version_idx" ON "trained_models"("version");

-- CreateIndex
CREATE INDEX "trained_models_deployedAt_idx" ON "trained_models"("deployedAt");

-- CreateIndex
CREATE UNIQUE INDEX "training_batches_batchId_key" ON "training_batches"("batchId");

-- CreateIndex
CREATE INDEX "training_batches_scenarioId_idx" ON "training_batches"("scenarioId");

-- CreateIndex
CREATE INDEX "training_batches_status_createdAt_idx" ON "training_batches"("status", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "trajectories_trajectoryId_key" ON "trajectories"("trajectoryId");

-- CreateIndex
CREATE INDEX "trajectories_agentId_startTime_idx" ON "trajectories"("agentId", "startTime");

-- CreateIndex
CREATE INDEX "trajectories_aiJudgeReward_idx" ON "trajectories"("aiJudgeReward");

-- CreateIndex
CREATE INDEX "trajectories_isTrainingData_usedInTraining_idx" ON "trajectories"("isTrainingData", "usedInTraining");

-- CreateIndex
CREATE INDEX "trajectories_scenarioId_createdAt_idx" ON "trajectories"("scenarioId", "createdAt");

-- CreateIndex
CREATE INDEX "trajectories_trainedInBatch_idx" ON "trajectories"("trainedInBatch");

-- CreateIndex
CREATE INDEX "trajectories_windowId_agentId_idx" ON "trajectories"("windowId", "agentId");

-- CreateIndex
CREATE INDEX "trajectories_windowId_idx" ON "trajectories"("windowId");

-- CreateIndex
CREATE UNIQUE INDEX "reward_judgments_trajectoryId_key" ON "reward_judgments"("trajectoryId");

-- CreateIndex
CREATE INDEX "reward_judgments_overallScore_idx" ON "reward_judgments"("overallScore");

-- CreateIndex
CREATE INDEX "reward_judgments_groupId_rank_idx" ON "reward_judgments"("groupId", "rank");

-- CreateIndex
CREATE INDEX "UserBlock_blockerId_idx" ON "UserBlock"("blockerId");

-- CreateIndex
CREATE INDEX "UserBlock_blockedId_idx" ON "UserBlock"("blockedId");

-- CreateIndex
CREATE INDEX "UserBlock_createdAt_idx" ON "UserBlock"("createdAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "UserBlock_blockerId_blockedId_key" ON "UserBlock"("blockerId", "blockedId");

-- CreateIndex
CREATE INDEX "UserMute_muterId_idx" ON "UserMute"("muterId");

-- CreateIndex
CREATE INDEX "UserMute_mutedId_idx" ON "UserMute"("mutedId");

-- CreateIndex
CREATE INDEX "UserMute_createdAt_idx" ON "UserMute"("createdAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "UserMute_muterId_mutedId_key" ON "UserMute"("muterId", "mutedId");

-- CreateIndex
CREATE INDEX "Report_reporterId_idx" ON "Report"("reporterId");

-- CreateIndex
CREATE INDEX "Report_reportedUserId_idx" ON "Report"("reportedUserId");

-- CreateIndex
CREATE INDEX "Report_reportedPostId_idx" ON "Report"("reportedPostId");

-- CreateIndex
CREATE INDEX "Report_status_idx" ON "Report"("status");

-- CreateIndex
CREATE INDEX "Report_priority_status_idx" ON "Report"("priority", "status");

-- CreateIndex
CREATE INDEX "Report_category_idx" ON "Report"("category");

-- CreateIndex
CREATE INDEX "Report_createdAt_idx" ON "Report"("createdAt" DESC);

-- CreateIndex
CREATE INDEX "Report_reportedUserId_status_idx" ON "Report"("reportedUserId", "status");

-- CreateIndex
CREATE INDEX "Report_reportedPostId_status_idx" ON "Report"("reportedPostId", "status");

-- CreateIndex
CREATE INDEX "WorldFact_category_isActive_idx" ON "WorldFact"("category", "isActive");

-- CreateIndex
CREATE INDEX "WorldFact_priority_idx" ON "WorldFact"("priority" DESC);

-- CreateIndex
CREATE INDEX "WorldFact_lastUpdated_idx" ON "WorldFact"("lastUpdated" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "WorldFact_category_key_key" ON "WorldFact"("category", "key");

-- CreateIndex
CREATE INDEX "RSSFeedSource_isActive_lastFetched_idx" ON "RSSFeedSource"("isActive", "lastFetched");

-- CreateIndex
CREATE INDEX "RSSFeedSource_category_idx" ON "RSSFeedSource"("category");

-- CreateIndex
CREATE INDEX "RSSHeadline_sourceId_publishedAt_idx" ON "RSSHeadline"("sourceId", "publishedAt" DESC);

-- CreateIndex
CREATE INDEX "RSSHeadline_publishedAt_idx" ON "RSSHeadline"("publishedAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "ParodyHeadline_originalHeadlineId_key" ON "ParodyHeadline"("originalHeadlineId");

-- CreateIndex
CREATE INDEX "ParodyHeadline_isUsed_generatedAt_idx" ON "ParodyHeadline"("isUsed", "generatedAt" DESC);

-- CreateIndex
CREATE INDEX "ParodyHeadline_generatedAt_idx" ON "ParodyHeadline"("generatedAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "CharacterMapping_realName_key" ON "CharacterMapping"("realName");

-- CreateIndex
CREATE INDEX "CharacterMapping_category_isActive_idx" ON "CharacterMapping"("category", "isActive");

-- CreateIndex
CREATE INDEX "CharacterMapping_priority_idx" ON "CharacterMapping"("priority" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationMapping_realName_key" ON "OrganizationMapping"("realName");

-- CreateIndex
CREATE INDEX "OrganizationMapping_category_isActive_idx" ON "OrganizationMapping"("category", "isActive");

-- CreateIndex
CREATE INDEX "OrganizationMapping_priority_idx" ON "OrganizationMapping"("priority" DESC);

-- CreateIndex
CREATE INDEX "Chat_groupId_idx" ON "Chat"("groupId");

-- CreateIndex
CREATE INDEX "Market_onChainMarketId_idx" ON "Market"("onChainMarketId");

-- CreateIndex
CREATE INDEX "Notification_groupId_idx" ON "Notification"("groupId");

-- CreateIndex
CREATE INDEX "Notification_inviteId_idx" ON "Notification"("inviteId");

-- CreateIndex
CREATE INDEX "Post_originalPostId_idx" ON "Post"("originalPostId");

-- CreateIndex
CREATE UNIQUE INDEX "Question_oracleSessionId_key" ON "Question"("oracleSessionId");

-- CreateIndex
CREATE INDEX "Question_oraclePublishedAt_idx" ON "Question"("oraclePublishedAt");

-- CreateIndex
CREATE INDEX "Question_oracleSessionId_idx" ON "Question"("oracleSessionId");

-- CreateIndex
CREATE INDEX "User_agentCount_idx" ON "User"("agentCount" DESC);

-- CreateIndex
CREATE INDEX "User_autonomousTrading_idx" ON "User"("autonomousTrading");

-- CreateIndex
CREATE INDEX "User_isAgent_idx" ON "User"("isAgent");

-- CreateIndex
CREATE INDEX "User_isAgent_managedBy_idx" ON "User"("isAgent", "managedBy");

-- CreateIndex
CREATE INDEX "User_managedBy_idx" ON "User"("managedBy");

-- CreateIndex
CREATE INDEX "User_totalAgentPnL_idx" ON "User"("totalAgentPnL" DESC);

-- AddForeignKey
ALTER TABLE "AgentLog" ADD CONSTRAINT "AgentLog_agentUserId_fkey" FOREIGN KEY ("agentUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgentMessage" ADD CONSTRAINT "AgentMessage_agentUserId_fkey" FOREIGN KEY ("agentUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgentGoal" ADD CONSTRAINT "AgentGoal_agentUserId_fkey" FOREIGN KEY ("agentUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgentGoalAction" ADD CONSTRAINT "AgentGoalAction_goalId_fkey" FOREIGN KEY ("goalId") REFERENCES "AgentGoal"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgentGoalAction" ADD CONSTRAINT "AgentGoalAction_agentUserId_fkey" FOREIGN KEY ("agentUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgentPointsTransaction" ADD CONSTRAINT "AgentPointsTransaction_agentUserId_fkey" FOREIGN KEY ("agentUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgentPointsTransaction" ADD CONSTRAINT "AgentPointsTransaction_managerUserId_fkey" FOREIGN KEY ("managerUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgentTrade" ADD CONSTRAINT "AgentTrade_agentUserId_fkey" FOREIGN KEY ("agentUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_originalPostId_fkey" FOREIGN KEY ("originalPostId") REFERENCES "Post"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProfileUpdateLog" ADD CONSTRAINT "ProfileUpdateLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TwitterOAuthToken" ADD CONSTRAINT "TwitterOAuthToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_managedBy_fkey" FOREIGN KEY ("managedBy") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trajectories" ADD CONSTRAINT "trajectories_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reward_judgments" ADD CONSTRAINT "reward_judgments_trajectoryId_fkey" FOREIGN KEY ("trajectoryId") REFERENCES "trajectories"("trajectoryId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserBlock" ADD CONSTRAINT "UserBlock_blockerId_fkey" FOREIGN KEY ("blockerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserBlock" ADD CONSTRAINT "UserBlock_blockedId_fkey" FOREIGN KEY ("blockedId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserMute" ADD CONSTRAINT "UserMute_muterId_fkey" FOREIGN KEY ("muterId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserMute" ADD CONSTRAINT "UserMute_mutedId_fkey" FOREIGN KEY ("mutedId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_reportedUserId_fkey" FOREIGN KEY ("reportedUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_resolvedBy_fkey" FOREIGN KEY ("resolvedBy") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RSSHeadline" ADD CONSTRAINT "RSSHeadline_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES "RSSFeedSource"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParodyHeadline" ADD CONSTRAINT "ParodyHeadline_originalHeadlineId_fkey" FOREIGN KEY ("originalHeadlineId") REFERENCES "RSSHeadline"("id") ON DELETE CASCADE ON UPDATE CASCADE;
