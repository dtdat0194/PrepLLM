import React, { useState } from 'react';
import 'katex/dist/katex.min.css';
import { InlineMath, BlockMath } from 'react-katex';

const QuestionList = ({ questions, onAnswerChange }) => {
  const [answers, setAnswers] = useState({});
  const [showExplanations, setShowExplanations] = useState({});

  const handleAnswerSelect = (questionId, answer) => {
    const newAnswers = { ...answers, [questionId]: answer };
    setAnswers(newAnswers);
    onAnswerChange && onAnswerChange(questionId, answer);
  };

  const handleGridInChange = (questionId, value) => {
    const newAnswers = { ...answers, [questionId]: value };
    setAnswers(newAnswers);
    onAnswerChange && onAnswerChange(questionId, value);
  };

  const toggleExplanation = (questionId) => {
    setShowExplanations(prev => ({
      ...prev,
      [questionId]: !prev[questionId]
    }));
  };

  // Function to clean and decode HTML entities
  const decodeHtmlEntities = (text) => {
    const textarea = document.createElement('textarea');
    textarea.innerHTML = text;
    return textarea.value;
  };

  // Function to extract and clean math content
  const extractMathContent = (mathElement) => {
    if (!mathElement) return '';
    
    // Remove HTML tags and decode entities
    let content = mathElement.replace(/<[^>]*>/g, '');
    content = decodeHtmlEntities(content);
    
    // Clean up common MathML patterns
    content = content
      .replace(/&nbsp;/g, ' ')
      .replace(/&ldquo;/g, '"')
      .replace(/&rdquo;/g, '"')
      .replace(/&rsquo;/g, "'")
      .replace(/&mdash;/g, '—')
      .replace(/&hellip;/g, '...')
      .replace(/\s+/g, ' ')
      .trim();
    
    return content;
  };

  // Function to render content with proper math handling and structure
  const renderContent = (content) => {
    if (!content) return null;
    
    // Decode HTML entities first
    let decodedContent = decodeHtmlEntities(content);
    
    // Handle complex MathML patterns
    const mathPatterns = [
      /<math[^>]*alttext="([^"]*)"[^>]*>(.*?)<\/math>/g,
      /<math[^>]*>(.*?)<\/math>/g
    ];
    
    let processedContent = decodedContent;
    
    // Replace math elements with placeholders and store them
    const mathElements = [];
    let mathIndex = 0;
    
    mathPatterns.forEach(pattern => {
      processedContent = processedContent.replace(pattern, (match, alttext, mathContent) => {
        const cleanMath = extractMathContent(match);
        mathElements.push({
          index: mathIndex,
          content: cleanMath,
          alttext: alttext || cleanMath
        });
        return `__MATH_${mathIndex}__`;
      });
      mathIndex++;
    });
    
    // Split content by math placeholders
    const parts = processedContent.split(/(__MATH_\d+__)/);
    
    return parts.map((part, index) => {
      if (part.startsWith('__MATH_') && part.endsWith('__')) {
        const mathIndex = parseInt(part.match(/\d+/)[0]);
        const mathElement = mathElements.find(el => el.index === mathIndex);
        
        if (mathElement) {
          try {
            return (
              <InlineMath key={index} math={mathElement.content} />
            );
          } catch (error) {
            // Fallback to text if math rendering fails
            return (
              <span key={index} className="math-fallback">
                {mathElement.alttext || mathElement.content}
              </span>
            );
          }
        }
      }
      
      // Render regular text with HTML
      return (
        <span 
          key={index} 
          dangerouslySetInnerHTML={{ __html: part }}
        />
      );
    });
  };

  const getDifficultyLabel = (difficulty) => {
    switch (difficulty) {
      case 1: return 'Easy';
      case 2: return 'Medium';
      case 3: return 'Hard';
      default: return difficulty;
    }
  };

  const getTypeLabel = (type) => {
    switch (type) {
      case 'multiple-choice': return 'Multiple Choice';
      case 'grid-in': return 'Grid-In';
      default: return type;
    }
  };

  const getDifficultyColor = (difficulty) => {
    switch (difficulty) {
      case 1: return 'bg-green-100 text-green-800';
      case 2: return 'bg-yellow-100 text-yellow-800';
      case 3: return 'bg-red-100 text-red-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  if (!questions || questions.length === 0) {
    return (
      <div className="bg-white p-8 rounded-lg shadow text-center">
        <div className="text-gray-500">
          No questions found with the current filters.
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {questions.map((question, index) => (
        <div key={question.id} className="bg-white p-6 rounded-lg shadow border-l-4 border-blue-500">
          {/* Question Header */}
          <div className="mb-4">
            <div className="flex justify-between items-start mb-3">
              <div>
                <h3 className="text-lg font-semibold text-gray-800 mb-2">
                  Question {index + 1}
                </h3>
                <div className="flex flex-wrap gap-2">
                  <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                    {question.section}
                  </span>
                  <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                    {question.domain}
                  </span>
                  <span className={`inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${getDifficultyColor(question.difficulty)}`}>
                    {getDifficultyLabel(question.difficulty)}
                  </span>
                  <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-orange-100 text-orange-800">
                    {getTypeLabel(question.type)}
                  </span>
                </div>
              </div>
              <div className="text-sm text-gray-500">
                ID: {question.questionId}
              </div>
            </div>
            
            <div className="text-sm text-gray-600 mb-2">
              <strong>Skill:</strong> {question.skill}
            </div>
          </div>

          {/* Question Content */}
          <div className="mb-4">
            {question.paragraph && (
              <div className="mb-4 p-4 bg-gray-50 rounded-lg">
                <div className="text-sm text-gray-600 mb-2">Passage:</div>
                <div className="question-content prose max-w-none">
                  {renderContent(question.paragraph)}
                </div>
              </div>
            )}
            
            <div className="question-content prose max-w-none">
              {renderContent(question.questionText)}
            </div>
          </div>

          {/* Answer Options */}
          {question.type === 'multiple-choice' && question.choices && question.choices.length > 0 && (
            <div className="mb-4">
              <h4 className="text-md font-medium text-gray-800 mb-3">Choose the correct answer:</h4>
              <div className="space-y-2">
                {question.choices.map((choice, choiceIndex) => {
                  const choiceLetter = String.fromCharCode(65 + choiceIndex); // A, B, C, D...
                  const isSelected = answers[question.id] === choiceLetter;
                  
                  return (
                    <button
                      key={choiceIndex}
                      onClick={() => handleAnswerSelect(question.id, choiceLetter)}
                      className={`choice-button w-full text-left border rounded-lg transition-colors p-3 ${
                        isSelected 
                          ? 'border-blue-500 bg-blue-50 text-blue-800' 
                          : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'
                      }`}
                    >
                      <span className="font-medium mr-3 text-lg">{choiceLetter}.</span>
                      <span className="question-content">
                        {renderContent(choice)}
                      </span>
                    </button>
                  );
                })}
              </div>
            </div>
          )}

          {/* Grid-In Input */}
          {question.type === 'grid-in' && (
            <div className="mb-4">
              <h4 className="text-md font-medium text-gray-800 mb-3">Enter your answer:</h4>
              <input
                type="text"
                value={answers[question.id] || ''}
                onChange={(e) => handleGridInChange(question.id, e.target.value)}
                placeholder="Enter your answer..."
                className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
          )}

          {/* Correct Answer */}
          {question.correctAnswer && question.correctAnswer.length > 0 && (
            <div className="mb-4">
              <h4 className="text-md font-medium text-gray-800 mb-2">Correct Answer(s):</h4>
              <div className="flex flex-wrap gap-2">
                {question.correctAnswer.map((answer, answerIndex) => (
                  <span
                    key={answerIndex}
                    className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800"
                  >
                    {answer}
                  </span>
                ))}
              </div>
            </div>
          )}

          {/* Explanation */}
          {question.explanation && (
            <div className="mb-4">
              <button
                onClick={() => toggleExplanation(question.id)}
                className="text-blue-600 hover:text-blue-800 font-medium mb-2"
              >
                {showExplanations[question.id] ? 'Hide' : 'Show'} Explanation
              </button>
              
              {showExplanations[question.id] && (
                <div className="explanation-content bg-blue-50 p-4 rounded-lg">
                  <div className="question-content prose max-w-none">
                    {renderContent(question.explanation)}
                  </div>
                </div>
              )}
            </div>
          )}
        </div>
      ))}
    </div>
  );
};

export default QuestionList;
