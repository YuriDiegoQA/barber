import React from 'react';

export const Home: React.FC = () => {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900">BarberShop</h1>
        <p className="mt-2 text-gray-600">Bem-vindo ao nosso sistema de agendamentos</p>
      </div>
    </div>
  );
};