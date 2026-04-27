# Manduna Reservas — Site na internet (passo a passo)

Este projeto é o seu sistema de **reservas e leads do Manduna** rodando em **HTML estático + Supabase**, hospedado de graça em **Vercel** (URL pública na internet, com login da equipe).

Tempo estimado: **20 a 30 minutos** (mais rápido que o anterior porque já temos só um arquivo HTML, sem Next.js). Você já tem as 3 contas do projeto anterior, então pode pular a Etapa 1.

---

## O que você já tem (do projeto anterior)

- Conta no **GitHub** ✓
- Conta no **Supabase** ✓
- Conta no **Vercel** ✓
- **GitHub Desktop** instalado ✓

Se faltar alguma dessas, volte ao README do `manduna-spend-web` e faça os passos da Etapa 1 (são as mesmas contas; vamos só criar um projeto novo dentro de cada uma).

---

## ETAPA 1 — Subir o banco no Supabase

### 1.1 Criar projeto

1. Entre em https://supabase.com/dashboard.
2. Clique **New project**.
3. Nome do projeto: `manduna-reservas`
4. Database Password: clique em gerar e **copie a senha** num lugar seguro (Notes do Mac, Bitwarden, papel — onde for).
5. Region: **South America (São Paulo)** se aparecer; senão deixe o default.
6. Plan: **Free**.
7. Clique **Create new project** e espere 1–2 minutos.

### 1.2 Criar a tabela e as regras de segurança

1. No menu da esquerda, clique no ícone **SQL Editor** (parece `</>`).
2. Clique **+ New query**.
3. Abra o arquivo `supabase_setup.sql` desta pasta num editor de texto (TextEdit ou VS Code servem).
4. Copie TODO o conteúdo e cole no SQL Editor do Supabase.
5. Clique **Run** (canto inferior direito). Deve aparecer "Success. No rows returned".

Pronto — a tabela `reservas` foi criada com Row Level Security ativado (só quem estiver logado consegue ver os dados).

### 1.3 Importar os 80 clientes (CSV)

1. No menu da esquerda, clique **Table Editor**.
2. Você verá a tabela `reservas` listada. Clique nela.
3. No canto superior direito, clique **Insert** → **Import data from CSV**.
4. Selecione o arquivo `reservas_seed.csv` desta pasta.
5. Confirme que as colunas batem (id, name, email, etc.). Clique **Import data**.
6. Espere uns 10 segundos. Vai dizer "Successfully imported 80 rows".

### 1.4 Pegar as credenciais

1. No menu da esquerda, clique **Project Settings** (engrenagem na base) → **API**.
2. **Anote em algum lugar:**
   - **Project URL**: `https://XXXXX.supabase.co`
   - **anon public**: uma string longa começando com `eyJ...`

### 1.5 Criar os usuários que vão acessar o site

1. Menu esquerdo → **Authentication** → **Users**.
2. Clique **Add user** → **Create new user**.
3. Email: o seu email (ex: `aabarruda1301@gmail.com`).
4. Password: escolha uma senha (pelo menos 6 caracteres).
5. **Auto Confirm User**: marque sim.
6. Clique **Create user**.

> **Repita esse passo para cada pessoa da equipe** que vai usar o sistema (recepção, financeiro, etc.). Cada uma com email e senha próprios.

---

## ETAPA 2 — Colar suas credenciais no `index.html`

Diferente do projeto anterior, este não tem build step do Next.js. Você precisa colar as duas chaves direto no HTML (é seguro — explico no fim).

1. Abra o arquivo `index.html` desta pasta no **TextEdit**, **VS Code**, ou qualquer editor de texto.
2. Procure por estas duas linhas perto do topo do `<script>`:

   ```js
   const SUPABASE_URL      = "COLE_AQUI_A_URL_DO_PROJETO";
   const SUPABASE_ANON_KEY = "COLE_AQUI_A_ANON_PUBLIC_KEY";
   ```

3. Substitua os textos `COLE_AQUI_...` pelos valores que você copiou no passo **1.4** (mantendo as aspas):

   ```js
   const SUPABASE_URL      = "https://abcdefgh.supabase.co";
   const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...";
   ```

4. Salve o arquivo.

> **Por que é seguro colocar essas chaves no GitHub?** A `anon public key` foi desenhada para ficar em código de frontend — qualquer um que abrir o site no navegador vê ela mesmo. O que protege os dados é o **Row Level Security** (RLS), configurado no `supabase_setup.sql`: sem login, ninguém consegue ler nem escrever nada na tabela.

---

## ETAPA 3 — Subir o código no GitHub

### 3.1 Criar o repositório local

1. Abra o **GitHub Desktop**.
2. Menu **File** → **Add Local Repository**.
3. Clique **Choose...** e selecione esta pasta: `Documents/Claude/Projects/Sistema de Booking para o Manduna/manduna-reservas-web`.
4. Vai aparecer "This directory does not appear to be a Git repository". Clique no link **create a repository**.
5. Confirme e clique **Create Repository**.

### 3.2 Publicar no GitHub

1. No GitHub Desktop, no topo, clique **Publish repository**.
2. Name: `manduna-reservas-web`
3. Pode deixar privado ou público — Vercel acessa os dois.
4. Clique **Publish Repository**.

Pronto. Seu código está na nuvem.

---

## ETAPA 4 — Colocar o site no ar (Vercel)

### 4.1 Importar o projeto

1. Vá em https://vercel.com/new.
2. Clique **Import** ao lado do repositório `manduna-reservas-web`.
3. Na próxima tela, **Vercel detecta automaticamente** que é um site estático (sem framework). Não precisa configurar nada.
4. **Não precisa adicionar Environment Variables** desta vez (suas chaves já estão no `index.html`).
5. Clique **Deploy**.

### 4.2 Esperar o deploy

Demora uns 30–60 segundos. Quando terminar:

> 🎉 Congratulations! Your project has been successfully deployed.

A URL vai ser algo como `https://manduna-reservas-web.vercel.app` — esse é o endereço **público** do seu site.

---

## ETAPA 5 — Testar

1. Abra a URL `https://manduna-reservas-web.vercel.app` (ou a sua).
2. Você verá a tela de login da equipe.
3. Entre com email e senha que criou no passo **1.5**.
4. Pronto — você vê os 80 clientes importados, e qualquer alteração que você ou outra pessoa da equipe fizer aparece em tempo real para todos.

---

## Como atualizar dados depois

### Editar uma reserva pontual

Basta clicar na linha da tabela e editar no modal. As alterações são salvas direto no Supabase e aparecem para todos.

### Adicionar várias reservas de uma vez (de um Excel novo, por exemplo)

1. Use o botão **Importar JSON** no site (canto direito da barra de ferramentas).
2. Ou, no Supabase: **Table Editor** → `reservas` → **Insert** → **Import data from CSV**.

> O "Import" sempre **adiciona ou atualiza** linhas (graças ao `id` único). Se quiser começar do zero, abra o SQL Editor e rode `TRUNCATE public.reservas;` antes do import.

### Fazer backup

No site, clique **Exportar JSON** (ou **Exportar CSV**) periodicamente. Salve numa pasta no Drive ou Dropbox. Em caso de acidente, dá pra restaurar com **Importar JSON**.

---

## Como adicionar um domínio próprio (opcional)

Se você tem um domínio (ex: `reservas.manduna.com.br`):

1. No Vercel, abra o projeto → **Settings** → **Domains**.
2. Cole o domínio e siga as instruções (1 ou 2 registros DNS no painel da empresa do domínio).
3. Em ~10 minutos seu site fica em `https://reservas.manduna.com.br`.

---

## Como dar acesso a mais pessoas da equipe

Sempre que quiser adicionar alguém:

1. Supabase → **Authentication** → **Users** → **Add user**.
2. Email + senha + Auto Confirm.
3. Mande o link `https://manduna-reservas-web.vercel.app` e os dados de login pra pessoa.

Para tirar o acesso de alguém, é só apagar o usuário no mesmo painel.

---

## Como atualizar o site (mudar layout, adicionar campos, corrigir bug)

1. Edite o `index.html` no VS Code ou TextEdit.
2. Salve.
3. No GitHub Desktop você verá a alteração. Escreva uma mensagem (ex: "Adicionado campo de telefone alternativo") e clique **Commit to main**.
4. Clique **Push origin**.
5. Vercel detecta automaticamente e faz redeploy em 30–60 segundos. Pronto, novo site no ar.

---

## Problemas comuns

**"⚠️ Configuração do Supabase ausente"** na tela de login: você esqueceu de colar a URL ou a anon key no `index.html` (Etapa 2). Edite, salve, commit e push.

**"Invalid login credentials"**: o usuário não foi criado, ou a senha está errada. Recrie no passo 1.5.

**Tela em branco depois do login** ou **erro "permission denied"**: o RLS está ativo mas as policies podem não ter sido criadas. Volte ao SQL Editor do Supabase e rode novamente o conteúdo de `supabase_setup.sql`.

**"Failed to fetch"**: provavelmente a URL do Supabase está errada (Etapa 2). Confira em **Project Settings → API**.

---

## O que você tem agora

- Banco PostgreSQL na nuvem (Supabase, free tier — limite de 500 MB; você usa pouquíssimo: 80 reservas ocupam ~50 KB).
- Site na internet com URL pública e login (Vercel, free tier).
- Múltiplos usuários: cada pessoa da equipe entra com login próprio, e todas vêem/editam a mesma base em tempo real.
- Atualizações automáticas: editou e fez push? Vercel faz redeploy sozinho.
- Backup local com 1 clique (botão "Exportar JSON" no próprio site).

Bem-vindo à internet 🚀
