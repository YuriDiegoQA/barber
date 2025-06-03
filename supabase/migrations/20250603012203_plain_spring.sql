/*
  # Initial Schema Setup for Barbershop Application

  1. Tables Created:
    - profiles: User profiles with role management
    - services: Available barbershop services
    - appointments: Customer appointments
    - appointment_services: Junction table for appointments and services
    - available_slots: Available time slots for appointments
    - rewards: Customer reward tracking
    - reward_settings: System-wide reward configuration

  2. Security:
    - Row Level Security (RLS) enabled on all tables
    - Appropriate policies for each table
    - Role-based access control

  3. Initial Data:
    - Sample services
    - Default available slots
    - Initial reward settings
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users (id),
  email TEXT NOT NULL,
  first_name TEXT,
  last_name TEXT,
  phone TEXT,
  role TEXT NOT NULL DEFAULT 'client',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create services table
CREATE TABLE IF NOT EXISTS services (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  description TEXT,
  duration INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users (id),
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  status TEXT NOT NULL DEFAULT 'booked',
  client_name TEXT,
  client_phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create appointment_services junction table
CREATE TABLE IF NOT EXISTS appointment_services (
  id SERIAL PRIMARY KEY,
  appointment_id INTEGER NOT NULL REFERENCES appointments (id) ON DELETE CASCADE,
  service_id INTEGER NOT NULL REFERENCES services (id) ON DELETE CASCADE
);

-- Create available_slots table
CREATE TABLE IF NOT EXISTS available_slots (
  id SERIAL PRIMARY KEY,
  day_of_week INTEGER NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  is_available BOOLEAN NOT NULL DEFAULT TRUE
);

-- Create rewards table
CREATE TABLE IF NOT EXISTS rewards (
  id SERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  service_count INTEGER NOT NULL DEFAULT 0,
  free_service_available BOOLEAN NOT NULL DEFAULT FALSE,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create reward_settings table
CREATE TABLE IF NOT EXISTS reward_settings (
  id SERIAL PRIMARY KEY,
  services_for_reward INTEGER NOT NULL DEFAULT 5,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointment_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE available_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE rewards ENABLE ROW LEVEL SECURITY;
ALTER TABLE reward_settings ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies
-- Profiles
CREATE POLICY "Users can read own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- Services
CREATE POLICY "Anyone can read services" ON services FOR SELECT USING (true);
CREATE POLICY "Only admins can modify services" ON services USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- Appointments
CREATE POLICY "Users can read own appointments" ON appointments FOR SELECT 
USING (auth.uid() = user_id OR EXISTS (
  SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
));

CREATE POLICY "Anyone can create appointments" ON appointments FOR INSERT WITH CHECK (true);

-- Available Slots
CREATE POLICY "Anyone can read available slots" ON available_slots FOR SELECT USING (true);
CREATE POLICY "Only admins can modify slots" ON available_slots USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- Rewards
CREATE POLICY "Users can read own rewards" ON rewards FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Only admins can modify rewards" ON rewards USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- Insert sample data
INSERT INTO services (name, price, description, duration) VALUES
('Corte de Cabelo', 35.00, 'Corte masculino completo', 30),
('Barba', 25.00, 'Acabamento e modelagem', 20),
('Corte + Barba', 55.00, 'Combo completo', 45);

-- Insert default available slots
INSERT INTO available_slots (day_of_week, start_time, end_time) VALUES
(1, '09:00', '10:00'),
(1, '10:00', '11:00'),
(1, '11:00', '12:00'),
(1, '14:00', '15:00'),
(1, '15:00', '16:00'),
(1, '16:00', '17:00');

-- Insert initial reward settings
INSERT INTO reward_settings (services_for_reward) VALUES (5);