const prisma = require('../models/prisma');

// Get all skills
const getSkills = async (req, res) => {
  try {
    const skills = await prisma.skill.findMany({
      orderBy: {
        description: 'asc'
      }
    });
    
    res.json(skills);
  } catch (error) {
    console.error('Error fetching skills:', error);
    res.status(500).json({ error: 'Failed to fetch skills' });
  }
};

module.exports = {
  getSkills
}; 