-- ============================================================================
-- Manduna Bookings — Supabase database setup
-- Run all of this at once in the Supabase SQL Editor.
-- ============================================================================

-- Drops previous runs (safe to re-run multiple times)
drop table if exists public.reservas cascade;

-- Main table: one row per booking/lead
create table public.reservas (
  id                    text primary key,
  name                  text not null,
  email                 text default '',
  whatsapp              text default '',
  origem                text default 'WhatsApp',
  quarto                text default '',
  pax                   integer default 0,
  diaria                numeric(10,2) default 0,
  folio                 text default '',

  primeiro_contato      date,
  cotacao_enviada       date,
  data_reserva          date,
  confirmacao           date,
  grupo_whatsapp        boolean default false,
  link_pagamento        text default '',
  deposito_data         date,
  pagamento_final_data  date,
  checkin               date,
  checkout              date,

  status_manual         text default '',
  obs                   text default '',

  created_at            timestamptz default now(),
  updated_at            timestamptz default now()
);

-- Indexes to speed up common queries
create index reservas_checkin_idx       on public.reservas (checkin);
create index reservas_origem_idx        on public.reservas (origem);
create index reservas_data_reserva_idx  on public.reservas (data_reserva);

-- Auto-update updated_at on every UPDATE
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists reservas_updated_at on public.reservas;
create trigger reservas_updated_at
  before update on public.reservas
  for each row execute function public.set_updated_at();

-- ============================================================================
-- Row Level Security (RLS) — only authenticated users can read/write
-- ============================================================================
alter table public.reservas enable row level security;

-- Policy: any authenticated user can do everything
drop policy if exists "auth_select" on public.reservas;
drop policy if exists "auth_insert" on public.reservas;
drop policy if exists "auth_update" on public.reservas;
drop policy if exists "auth_delete" on public.reservas;

create policy "auth_select"
  on public.reservas for select
  to authenticated
  using (true);

create policy "auth_insert"
  on public.reservas for insert
  to authenticated
  with check (true);

create policy "auth_update"
  on public.reservas for update
  to authenticated
  using (true) with check (true);

create policy "auth_delete"
  on public.reservas for delete
  to authenticated
  using (true);

-- ============================================================================
-- Done. Next step: import the CSV via the Table Editor.
-- ============================================================================
