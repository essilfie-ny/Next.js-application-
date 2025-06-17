'use client';
import { useEffect, useState } from 'react';

const TABLES = ['students', 'fees', 'courses'];

export default function Dashboard() {
  const [activeTab, setActiveTab] = useState('students');
  const [data, setData] = useState([]);
  const [error, setError] = useState('');

  useEffect(() => {
    fetch(`/api/${activeTab}`)
      .then((res) => res.json())
      .then((result) => {
        if (Array.isArray(result)) {
          setData(result);
          setError('');
        } else {
          setError(`Failed to load ${activeTab} data`);
        }
      })
      .catch((err) => {
        console.error(err);
        setError(`Error loading ${activeTab} data`);
      });
  }, [activeTab]);

  const renderTable = () => {
    if (!data.length) return <p className="p-4">No data available.</p>;

    const columns = Object.keys(data[0]);

    return (
      <div className="overflow-x-auto rounded-lg shadow border border-gray-300 bg-white mt-4">
        <table className="min-w-full text-md text-gray-800">
          <thead className="bg-blue-600 text-white">
            <tr>
              {columns.map((col) => (
                <th key={col} className="px-6 py-3 text-left font-semibold">
                  {col.replace(/_/g, ' ').toUpperCase()}
                </th>
              ))}
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-300">
            {data.map((row, index) => (
              <tr key={index} className="hover:bg-blue-50 transition-colors">
                {columns.map((col) => (
                  <td key={col} className="px-6 py-4">{row[col]}</td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  };

  return (
    <div className="min-h-screen bg-gray-100 p-6 text-gray-800">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Dashboard</h1>
        <span className="text-md font-semibold text-gray-700">Viewing: {activeTab.toUpperCase()}</span>
      </div>

      <div className="flex space-x-4 mb-4">
        {TABLES.map((table) => (
          <button
            key={table}
            className={`px-4 py-2 rounded ${
              activeTab === table
                ? 'bg-blue-600 text-white'
                : 'bg-white text-gray-700 border border-gray-300'
            }`}
            onClick={() => setActiveTab(table)}
          >
            {table.toUpperCase()}
          </button>
        ))}
      </div>

      {error ? (
        <p className="text-red-600">{error}</p>
      ) : (
        renderTable()
      )}
    </div>
  );
}
