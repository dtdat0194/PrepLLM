-- CreateTable
CREATE TABLE "public"."questions" (
    "id" TEXT NOT NULL,
    "uId" TEXT NOT NULL,
    "questionId" TEXT,
    "program" TEXT NOT NULL,
    "module" TEXT NOT NULL,
    "primaryClassCdDesc" TEXT,
    "skillCd" TEXT,
    "skillDesc" TEXT,
    "difficulty" TEXT NOT NULL,
    "scoreBandRangeCd" INTEGER,
    "pPcc" TEXT,
    "ibn" TEXT,
    "externalId" TEXT,
    "createDate" BIGINT,
    "updateDate" BIGINT,
    "templateId" TEXT,
    "vaultId" TEXT,
    "origin" TEXT,
    "contentType" TEXT,
    "stem" TEXT,
    "rationale" TEXT,
    "correctAnswer" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."answer_options" (
    "id" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "option" TEXT NOT NULL,
    "order" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "answer_options_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."skills" (
    "code" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "skills_pkey" PRIMARY KEY ("code")
);

-- CreateTable
CREATE TABLE "public"."modules" (
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "modules_pkey" PRIMARY KEY ("name")
);

-- CreateIndex
CREATE UNIQUE INDEX "questions_uId_key" ON "public"."questions"("uId");

-- AddForeignKey
ALTER TABLE "public"."questions" ADD CONSTRAINT "questions_skillCd_fkey" FOREIGN KEY ("skillCd") REFERENCES "public"."skills"("code") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."questions" ADD CONSTRAINT "questions_module_fkey" FOREIGN KEY ("module") REFERENCES "public"."modules"("name") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."answer_options" ADD CONSTRAINT "answer_options_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "public"."questions"("id") ON DELETE CASCADE ON UPDATE CASCADE;
