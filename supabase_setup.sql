-- ============================================================================
-- Manduna Reservas — Setup do banco no Supabase
-- Rode tudo de uma vez no SQL Editor do Supabase.
-- ============================================================================

-- Limpa execuções anteriores (seguro rodar várias vezes)
drop table if exists public.reservas cascade;

-- Tabela principal: uma linha por reserva/lead
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

-- Índices para acelerar buscas comuns
create index reservas_checkin_idx       on public.reservas (checkin);
create index reservas_origem_idx        on public.reservas (origem);
create index reservas_data_reserva_idx  on public.reservas (data_reserva);

-- Atualiza updated_at automaticamente em qualquer UPDATE
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
-- Row Level Security (RLS) — só usuários logados podem ver/editar
-- ============================================================================
alter table public.reservas enable row level security;

-- Política: qualquer usuário autenticado pode fazer qualquer coisa
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
-- Pronto. Próximo passo: importar o CSV pelo Table Editor.
-- ============================================================================
