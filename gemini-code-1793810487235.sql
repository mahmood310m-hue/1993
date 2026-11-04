-- 1. جدول المستخدمين والملفات الشخصية المرتبط بـ auth.users
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text not null,
  phone text unique not null,
  role text check (role in ('super_admin', 'admin', 'teacher', 'student', 'parent')) default 'student',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

enable row level security on public.profiles;

-- 2. جدول الإعلانات والأخبار المتحركة
create table public.announcements (
  id serial primary key,
  title text not null,
  content text not null,
  type text check (type in ('news', 'announcement', 'exam', 'holiday')) default 'announcement',
  is_ticker boolean default false,
  image_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

enable row level security on public.announcements;
create policy "Enable read access for all users" on public.announcements for select using (true);
create policy "Enable all actions for admins" on public.announcements for all using (
  exists (select 1 from public.profiles where id = auth.uid() and role in ('super_admin', 'admin'))
);

-- 3. جدول الطلبة والإحصائيات
create table public.students (
  id serial primary key,
  full_name text not null,
  phone text,
  class_name text not null,
  stage text not null,
  gpa numeric(5,2),
  is_excel boolean default false,
  parent_id uuid references public.profiles(id),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

enable row level security on public.students;
create policy "Allow read for authenticated users" on public.students for select to authenticated using (true);
create policy "Allow write for admins" on public.students for all using (
  exists (select 1 from public.profiles where id = auth.uid() and role in ('super_admin', 'admin'))
);