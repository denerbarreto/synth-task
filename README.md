# Synth Task

Essa é a API para o aplicativo Synth Task, que permite a criação, edição e gerenciamento de projetos e tarefas para usuários.

## Tecnologias utilizadas

- Ruby on Rails
- PostgreSQL
- Docke

## Como Utilizar

Para utilizar a API, você precisará do Docker e do Docker Compose instalado em sua máquina.

Clone o repositório:

```sh
git clone https://github.com/denerbarreto/synth-task.git
```

Na pasta do projeto, construa a imagem:

```sh
docker compose build
```

Inicie os containers:

```sh
docker compose up -d
```

Crie o banco de dados e faça as migraçoes:

```sh
docker compose exec app rails db:create db:migrate
```

A api estará disponível em:

```sh
http://localhost:3000
```

## Rotas disponíveis e Utilização

A seguir estão listadas as rotas disponíveis na API, divididas por recurso:

#### Authenticação

| Método | Endpoint               | Descrição            |
| ------ | ---------------------- | -------------------- |
| POST   | **_/api/v1/sessions_** | cria uma nova sessão |
| DELETE | **_/api/v1/sessions_** | deleta uma sessão    |

Exemplo de como criar uma sessão:

```json
{
  "user": {
    "email": "usuario@email.com",
    "password": "senhadousuario"
  }
}
```

A resposta conterá um token de acesso, que deverá ser enviado nas requisições subsequentes no header Authorization com o valor "Bearer SEU_TOKEN_AQUI"

#### Usuários

| Método | Endpoint                | Descrição            |
| ------ | ----------------------- | -------------------- |
| POST   | **_/api/v1/users_**     | cria um novo usuário |
| GET    | **_/api/v1/users/:id_** | mostra o usuário     |
| PATCH  | **_/api/v1/users/:id_** | edita um usuário     |
| DELETE | **_/api/v1/users/:id_** | deleta o usuário     |

Exemplo de como criar um usuário:

```json
{
  "user": {
    "name": "Nome do usuário",
    "email": "usuario@email.com",
    "password": "senhadousuario",
    "password_confirmation": "senhadousuario"
  }
}
```

#### Projetos

| Método | Endpoint                   | Descrição               |
| ------ | -------------------------- | ----------------------- |
| POST   | **_/api/v1/projects_**     | cria um novo projeto    |
| GET    | **_/api/v1/projects_**     | mostra todos os projeto |
| GET    | **_/api/v1/projects/:id_** | mostra o projeto        |
| PATCH  | **_/api/v1/projects/:id_** | edita um projeto        |
| DELETE | **_/api/v1/projects/:id_** | deleta o projeto        |

Exemplo de como criar um projeto:

```json
{
  "project": {
    "name": "Nome do Projeto"
  }
}
```

#### Lista de Tarefas

| Método | Endpoint                                                    | Descrição                        |
| ------ | ----------------------------------------------------------- | -------------------------------- |
| POST   | **_/api/v1/projects/:project_id/task_lists_**               | cria uma nova lista de tarefa    |
| GET    | **_/api/v1/projects/:project_id/task_lists_**               | mostra todas as lista de tarefas |
| PATCH  | **_/api/v1/projects/:project_id/task_lists/:task_list_id_** | edita uma lista de tarefa        |
| DELETE | **_/api/v1/projects/:project_id/task_lists/:task_list_id_** | deleta a lista de tarefa         |

Exemplo de como criar uma lista de tarefas:

> /api/v1/projects/1/task_lists

```json
{
  "task_list": {
    "name": "Nome do Lista de Tarefas",
    "order": 1
  }
}
```

#### Tarefas

| Método | Endpoint                                                                   | Descrição               |
| ------ | -------------------------------------------------------------------------- | ----------------------- |
| POST   | **_/api/v1/projects/:project_id/task_lists/:task_list_id/tasks_**          | cria uma nova tarefa    |
| GET    | **_/api/v1/projects/:project_id/task_lists/:task_list_id/tasks_**          | mostra todas as tarefas |
| PATCH  | **_/api/v1/projects/:project_id/task_lists/:task_list_id/tasks/:task_id_** | edita uma tarefa        |
| DELETE | **_/api/v1/projects/:project_id/task_lists/:task_list_id/tasks/:task_id_** | deleta uma tarefa       |

Exemplo de como criar uma tarefa:

> /api/v1/projects/1/task_lists/1/tasks

```json
{
  "task": {
    "name": "Nome da Tarefa",
    "description": "Descrição da tarefa",
    "date_start": "2023-01-22",
    "date_end": "2023-02-22",
    "status": "Em andamento",
    "priority": 1
  }
}
```

## Observações

- Os dados são passados no formato JSON
- As rotas só estão disponíveis para usuários autenticados

## License

MIT
