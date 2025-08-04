import React, { useState, useEffect } from 'react';
import 'katex/dist/katex.min.css';
import { InlineMath, BlockMath } from 'react-katex';

const QuestionViewer = ({ questions, currentIndex, onNavigate, onAnswerChange, globalQuestionNumber = 1, totalQuestions = 0 }) => {
  const [selectedAnswer, setSelectedAnswer] = useState('');
  const [showExplanation, setShowExplanation] = useState(false);
  const [gridInValue, setGridInValue] = useState('');

  const currentQuestion = questions[currentIndex];

  useEffect(() => {
    // Reset state when question changes
    setSelectedAnswer('');
    setShowExplanation(false);
    setGridInValue('');
  }, [currentIndex]);

  const handleAnswerSelect = (answer) => {
    setSelectedAnswer(answer);
    onAnswerChange && onAnswerChange(answer);
  };

  const handleGridInChange = (value) => {
    setGridInValue(value);
    onAnswerChange && onAnswerChange(value);
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

  // Function to render structured content with proper formatting
  const renderStructuredContent = (content) => {
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

  if (!currentQuestion) {
    return (
      <div className="bg-white p-6 rounded-lg shadow">
        <div className="text-center text-gray-500">
          No question selected
        </div>
      </div>
    );
  }

  return (
    <div className="bg-white p-6 rounded-lg shadow">
      {/* Question Header */}
      <div className="mb-6">
        <div className="flex justify-between items-start mb-4">
          <div>
            <h2 className="text-xl font-semibold text-gray-800 mb-2">
              Question {globalQuestionNumber} of {totalQuestions}
            </h2>
            <div className="flex flex-wrap gap-2">
              <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                {currentQuestion.section}
              </span>
              <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                {currentQuestion.domain}
              </span>
              <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                {getDifficultyLabel(currentQuestion.difficulty)}
              </span>
              <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-orange-100 text-orange-800">
                {getTypeLabel(currentQuestion.type)}
              </span>
            </div>
          </div>
          <div className="text-sm text-gray-500">
            ID: {currentQuestion.questionId}
          </div>
        </div>
        
        <div className="text-sm text-gray-600 mb-2">
          <strong>Skill:</strong> {currentQuestion.skill}
        </div>
      </div>

      {/* Question Content */}
      <div className="mb-6">
        {currentQuestion.paragraph && (
          <div className="mb-4 p-4 bg-gray-50 rounded-lg">
            <div className="text-sm text-gray-600 mb-2">Passage:</div>
            <div className="question-content prose max-w-none">
              {renderStructuredContent(currentQuestion.paragraph)}
            </div>
          </div>
        )}
        
        <div className="question-content prose max-w-none">
          {renderStructuredContent(currentQuestion.questionText)}
        </div>
      </div>

      {/* Answer Options */}
      {currentQuestion.type === 'multiple-choice' && currentQuestion.choices && currentQuestion.choices.length > 0 && (
        <div className="mb-6">
          <h3 className="text-lg font-medium text-gray-800 mb-3">Choose the correct answer:</h3>
          <div className="space-y-3">
            {currentQuestion.choices.map((choice, index) => {
              const choiceLetter = String.fromCharCode(65 + index); // A, B, C, D...
              const isSelected = selectedAnswer === choiceLetter;
              
              return (
                <button
                  key={index}
                  onClick={() => handleAnswerSelect(choiceLetter)}
                  className={`choice-button w-full text-left border rounded-lg transition-colors ${
                    isSelected ? 'selected' : ''
                  }`}
                >
                  <span className="font-medium mr-3 text-lg">{choiceLetter}.</span>
                  <span className="question-content">
                    {renderStructuredContent(choice)}
                  </span>
                </button>
              );
            })}
          </div>
        </div>
      )}

      {/* Grid-In Input */}
      {currentQuestion.type === 'grid-in' && (
        <div className="mb-6">
          <h3 className="text-lg font-medium text-gray-800 mb-3">Enter your answer:</h3>
          <input
            type="text"
            value={gridInValue}
            onChange={(e) => handleGridInChange(e.target.value)}
            placeholder="Enter your answer..."
            className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
      )}

      {/* Explanation */}
      {currentQuestion.explanation && (
        <div className="mb-6">
          <button
            onClick={() => setShowExplanation(!showExplanation)}
            className="text-blue-600 hover:text-blue-800 font-medium"
          >
            {showExplanation ? 'Hide' : 'Show'} Explanation
          </button>
          
          {showExplanation && (
            <div className="explanation-content">
              <div className="question-content prose max-w-none">
                {renderStructuredContent(currentQuestion.explanation)}
              </div>
            </div>
          )}
        </div>
      )}

      {/* Correct Answer */}
      {currentQuestion.correctAnswer && currentQuestion.correctAnswer.length > 0 && (
        <div className="mb-6">
          <h3 className="text-lg font-medium text-gray-800 mb-2">Correct Answer(s):</h3>
          <div className="flex flex-wrap gap-2">
            {currentQuestion.correctAnswer.map((answer, index) => (
              <span
                key={index}
                className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800"
              >
                {answer}
              </span>
            ))}
          </div>
        </div>
      )}

      {/* Navigation */}
      <div className="flex justify-between items-center pt-4 border-t border-gray-200">
        <button
          onClick={() => onNavigate(currentIndex - 1)}
          disabled={currentIndex === 0}
          className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Previous
        </button>
        
        <span className="text-sm text-gray-500">
          {globalQuestionNumber} of {totalQuestions}
        </span>
        
        <button
          onClick={() => onNavigate(currentIndex + 1)}
          disabled={currentIndex === questions.length - 1}
          className="px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Next
        </button>
      </div>
    </div>
  );
};

export default QuestionViewer; 