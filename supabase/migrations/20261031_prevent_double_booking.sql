-- Migration: Prevent double booking of appointments
-- Description: Ensures that no doctor can have more than one non-cancelled appointment at the same date and time.

-- 1. Create unique partial index on appointments table
CREATE UNIQUE INDEX IF NOT EXISTS unique_doctor_appointment_slot 
ON appointments (doctor_id, date, time) 
WHERE status != 'cancelled';

-- 2. Add comment explaining the index
COMMENT ON INDEX unique_doctor_appointment_slot IS 
'Prevents double-booking for the same doctor at the same date and time, while allowing re-booking if the appointment was cancelled.';

