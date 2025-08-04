import React, { useState, useEffect } from 'react';
import { questionsAPI } from '../api/api';

const FilterPanel = ({ onFiltersChange, currentQuestionIndex = 0, totalQuestions = 0 }) => {
  const [filters, setFilters] = useState({
    section: '',
    domain: '',
    skill: '',
    difficulty: '',
    type: ''
  });

  const [availableFilters, setAvailableFilters] = useState({
    sections: [],
    domains: [],
    skills: [],
    types: [],
    difficulties: [1, 2, 3]
  });

  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadFilters();
  }, []);

  const loadFilters = async () => {
    try {
      setLoading(true);
      const filterData = await questionsAPI.getFilters();
      setAvailableFilters(filterData);
    } catch (error) {
      console.error('Error loading filters:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleFilterChange = (filterType, value) => {
    const newFilters = { ...filters, [filterType]: value };
    setFilters(newFilters);
    onFiltersChange(newFilters);
  };

  const clearFilters = () => {
    const clearedFilters = {
      section: '',
      domain: '',
      skill: '',
      difficulty: '',
      type: ''
    };
    setFilters(clearedFilters);
    onFiltersChange(clearedFilters);
  };

  const getDifficultyLabel = (difficulty) => {
    switch (difficulty) {
      case 1: return 'Easy';
      case 2: return 'Medium';
      case 3: return 'Hard';
      default: return difficulty;
    }
  };

  if (loading) {
    return (
      <div className="bg-white p-4 rounded-lg shadow mb-4">
        <div className="animate-pulse">
          <div className="h-4 bg-gray-200 rounded mb-2"></div>
          <div className="h-4 bg-gray-200 rounded mb-2"></div>
          <div className="h-4 bg-gray-200 rounded"></div>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-white p-4 rounded-lg shadow mb-4">
      <div className="flex justify-between items-center mb-4">
        <h3 className="text-lg font-semibold text-gray-800">Filters</h3>
        <div className="flex items-center gap-3">
          {/* Question Counter Box */}
          <div className="bg-blue-50 border border-blue-200 rounded-lg px-3 py-2">
            <div className="text-xs text-blue-600 font-medium">Question</div>
            <div className="text-sm font-semibold text-blue-800">
              {currentQuestionIndex + 1}/{totalQuestions}
            </div>
          </div>
          <button
            onClick={clearFilters}
            className="text-sm text-blue-600 hover:text-blue-800"
          >
            Clear All
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {/* Section Filter */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Section
          </label>
          <select
            value={filters.section}
            onChange={(e) => handleFilterChange('section', e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">All Sections</option>
            {availableFilters.sections.map((section) => (
              <option key={section} value={section}>
                {section}
              </option>
            ))}
          </select>
        </div>

        {/* Domain Filter */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Domain
          </label>
          <select
            value={filters.domain}
            onChange={(e) => handleFilterChange('domain', e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">All Domains</option>
            {availableFilters.domains.map((domain) => (
              <option key={domain} value={domain}>
                {domain}
              </option>
            ))}
          </select>
        </div>

        {/* Skill Filter */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Skill
          </label>
          <select
            value={filters.skill}
            onChange={(e) => handleFilterChange('skill', e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">All Skills</option>
            {availableFilters.skills.map((skill) => (
              <option key={skill} value={skill}>
                {skill}
              </option>
            ))}
          </select>
        </div>

        {/* Difficulty Filter */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Difficulty
          </label>
          <select
            value={filters.difficulty}
            onChange={(e) => handleFilterChange('difficulty', e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">All Difficulties</option>
            {availableFilters.difficulties.map((difficulty) => (
              <option key={difficulty} value={difficulty}>
                {getDifficultyLabel(difficulty)}
              </option>
            ))}
          </select>
        </div>

        {/* Type Filter */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Type
          </label>
          <select
            value={filters.type}
            onChange={(e) => handleFilterChange('type', e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">All Types</option>
            {availableFilters.types.map((type) => (
              <option key={type} value={type}>
                {type === 'multiple-choice' ? 'Multiple Choice' : 'Grid-In'}
              </option>
            ))}
          </select>
        </div>
      </div>
    </div>
  );
};

export default FilterPanel; 