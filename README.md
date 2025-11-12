
# 🌿 EcoLife – Say No to Plastics
**An Eco-Habit Tracking Web App with Admin Portal, Supabase Integration, and Live Leaderboard**

EcoLife is a professional-grade sustainable habit tracker that helps users monitor and reduce their daily use of plastics.  
It promotes eco-awareness through plastic tracking, eco pledges, daily tips, challenges, and leaderboards. 

---

## 🧩 Key Features

### 👥 User Features
- ♻️ Plastic Tracker – Log daily plastic use (bottles, bags, cutlery)
- 📊 Dashboard & Leaderboard – Track eco-points and ranks
- 💡 Eco Tips – View daily tips, and submit your own for admin review
- 🙌 Take Pledge – Commit to sustainable lifestyle actions
- 🎯 Challenges – Join challenges to earn points
- 🏅 Real-time Leaderboard
- 👤 Google Sign-In / Guest Mode

### 🧑‍💼 Admin Features
- 🛡️ Admin Portal with full CRUD control:
  - Manage users (reset, delete, toggle admin)
  - Add, edit, delete challenges
  - Approve or reject user-submitted tips
  - Manage pledge options
  - Updates reflect instantly for all users (real-time sync)

---

## ⚙️ Setup Instructions

### 🧬 Supabase Setup
1. Create a Supabase project at https://supabase.com
2. Run the following SQL files in order:
   - `schema.sql`
   - `policies.sql`
   - `admin.sql`
   - `admin_extra.sql`
3. Enable Google Authentication in Supabase settings.
4. Add the credentials in `supabase.js`.

### 🖥️ Run Locally
```bash
cd public
python3 -m http.server 5173
```
Then open `http://localhost:5173` in your browser.

---

## 🧮 SQL Example: Add New Challenges
```sql
INSERT INTO public.challenges (title, description, "start", "end", points)
VALUES
('Reduce Plastic Bottles', 'Avoid single-use bottles for a week.', '2025-11-11', '2025-12-01', 50),
('Plastic-Free December', 'Participate in zero plastic month.', '2025-12-01', '2026-01-01', 75),
('Eco Bag Challenge', 'Use cloth bags for 10 days.', '2025-11-20', '2025-12-05', 40);
```

> ✅ Quoting "start" and "end" avoids SQL keyword conflicts.

---

## 🧑‍💼 Make a User Admin
```sql
UPDATE public.users SET is_admin = true WHERE email = 'admin@example.com';
```

---

## 📜 License

This project is licensed under the MIT License.

---

> Developed by **KOKKIRIGADDA VANITHA (2025)** – B.Tech Capstone Project.
> 
