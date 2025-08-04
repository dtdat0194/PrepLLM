/*
  Warnings:

  - You are about to drop the column `contentType` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `createDate` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `externalId` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `ibn` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `module` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `origin` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `pPcc` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `primaryClassCdDesc` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `rationale` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `scoreBandRangeCd` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `skillCd` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `skillDesc` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `stem` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `templateId` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `uId` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `updateDate` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `vaultId` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the `answer_options` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `modules` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `skills` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[questionId]` on the table `questions` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `domain` to the `questions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `questionText` to the `questions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `section` to the `questions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `skill` to the `questions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `questions` table without a default value. This is not possible if the table is not empty.
  - Made the column `questionId` on table `questions` required. This step will fail if there are existing NULL values in that column.
  - Changed the type of `difficulty` on the `questions` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- DropForeignKey
ALTER TABLE "answer_options" DROP CONSTRAINT "answer_options_questionId_fkey";

-- DropForeignKey
ALTER TABLE "questions" DROP CONSTRAINT "questions_module_fkey";

-- DropForeignKey
ALTER TABLE "questions" DROP CONSTRAINT "questions_skillCd_fkey";

-- DropIndex
DROP INDEX "questions_uId_key";

-- AlterTable
ALTER TABLE "questions" DROP COLUMN "contentType",
DROP COLUMN "createDate",
DROP COLUMN "externalId",
DROP COLUMN "ibn",
DROP COLUMN "module",
DROP COLUMN "origin",
DROP COLUMN "pPcc",
DROP COLUMN "primaryClassCdDesc",
DROP COLUMN "rationale",
DROP COLUMN "scoreBandRangeCd",
DROP COLUMN "skillCd",
DROP COLUMN "skillDesc",
DROP COLUMN "stem",
DROP COLUMN "templateId",
DROP COLUMN "uId",
DROP COLUMN "updateDate",
DROP COLUMN "vaultId",
ADD COLUMN     "choices" TEXT[],
ADD COLUMN     "domain" TEXT NOT NULL,
ADD COLUMN     "explanation" TEXT,
ADD COLUMN     "imageUrl" TEXT,
ADD COLUMN     "paragraph" TEXT,
ADD COLUMN     "questionText" TEXT NOT NULL,
ADD COLUMN     "section" TEXT NOT NULL,
ADD COLUMN     "skill" TEXT NOT NULL,
ADD COLUMN     "svgContent" TEXT,
ADD COLUMN     "type" TEXT NOT NULL,
ADD COLUMN     "visualType" TEXT,
ALTER COLUMN "questionId" SET NOT NULL,
DROP COLUMN "difficulty",
ADD COLUMN     "difficulty" INTEGER NOT NULL;

-- DropTable
DROP TABLE "answer_options";

-- DropTable
DROP TABLE "modules";

-- DropTable
DROP TABLE "skills";

-- CreateIndex
CREATE UNIQUE INDEX "questions_questionId_key" ON "questions"("questionId");
