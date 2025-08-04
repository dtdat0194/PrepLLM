import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import PracticePage from './pages/PracticePage';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/" element={<PracticePage />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
