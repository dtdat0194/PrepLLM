const prisma = require('../models/prisma');

// Get all modules
const getModules = async (req, res) => {
  try {
    const modules = await prisma.module.findMany({
      orderBy: {
        name: 'asc'
      }
    });
    
    res.json(modules);
  } catch (error) {
    console.error('Error fetching modules:', error);
    res.status(500).json({ error: 'Failed to fetch modules' });
  }
};

module.exports = {
  getModules
}; 