export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          email: string
          first_name: string | null
          last_name: string | null
          phone: string | null
          role: string
          created_at: string
        }
        Insert: {
          id: string
          email: string
          first_name?: string | null
          last_name?: string | null
          phone?: string | null
          role?: string
          created_at?: string
        }
        Update: {
          id?: string
          email?: string
          first_name?: string | null
          last_name?: string | null
          phone?: string | null
          role?: string
          created_at?: string
        }
      }
      services: {
        Row: {
          id: number
          name: string
          price: number
          description: string | null
          duration: number
          created_at: string
        }
        Insert: {
          id?: number
          name: string
          price: number
          description?: string | null
          duration: number
          created_at?: string
        }
        Update: {
          id?: number
          name?: string
          price?: number
          description?: string | null
          duration?: number
          created_at?: string
        }
      }
      appointments: {
        Row: {
          id: number
          user_id: string | null
          date: string
          status: string
          client_name: string | null
          client_phone: string | null
          created_at: string
        }
        Insert: {
          id?: number
          user_id?: string | null
          date: string
          status?: string
          client_name?: string | null
          client_phone?: string | null
          created_at?: string
        }
        Update: {
          id?: number
          user_id?: string | null
          date?: string
          status?: string
          client_name?: string | null
          client_phone?: string | null
          created_at?: string
        }
      }
    }
  }
}