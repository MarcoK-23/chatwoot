# Navigator AI Integration

Navigator is a new AI assistant integration for Chatwoot that provides intelligent conversation handling and automated responses. It's designed to be a lightweight alternative to Navigator, available outside the enterprise environment.

## Features

- **AI-Powered Conversations**: Intelligent responses using OpenAI's GPT models
- **Document Management**: Upload and manage knowledge base documents
- **Response Training**: Train the assistant with custom Q&A pairs
- **Inbox Integration**: Assign assistants to specific inboxes
- **Vector Search**: Semantic search through knowledge base using embeddings

## Setup

### 1. Enable the Feature

Navigator is enabled by default, but you can verify it's available:

```ruby
account.enable_features!('navigator_ai')
```

### 2. Environment Variables

Set up the required environment variables:

```bash
# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key
OPENAI_MODEL=gpt-4o-mini  # or your preferred model

# Vector Database (PostgreSQL with pgvector extension)
# Make sure your PostgreSQL has the vector extension enabled
```

### 3. Database Migration

Run the migration to create Navigator tables:

```bash
rails db:migrate
```

## Usage

### Creating an Assistant

```ruby
assistant = account.navigator_assistants.create!(
  name: 'Support Assistant',
  description: 'A helpful AI assistant for customer support',
  config: {
    product_name: 'My Product',
    temperature: 0.7
  }
)
```

### Adding Documents

```ruby
document = assistant.documents.create!(
  name: 'FAQ Document',
  external_link: 'https://example.com/faq',
  content: 'Your document content here...'
)
```

### Training Responses

```ruby
response = assistant.responses.create!(
  question: 'How do I reset my password?',
  answer: 'You can reset your password by clicking the "Forgot Password" link.',
  status: 'approved'
)
```

### Assigning to Inboxes

```ruby
assistant.navigator_inboxes.create!(inbox: inbox)
```

## API Endpoints

### Assistants

- `GET /api/v1/accounts/{account_id}/navigator/assistants` - List assistants
- `POST /api/v1/accounts/{account_id}/navigator/assistants` - Create assistant
- `GET /api/v1/accounts/{account_id}/navigator/assistants/{id}` - Get assistant
- `PUT /api/v1/accounts/{account_id}/navigator/assistants/{id}` - Update assistant
- `DELETE /api/v1/accounts/{account_id}/navigator/assistants/{id}` - Delete assistant

### Documents

- `GET /api/v1/accounts/{account_id}/navigator/documents` - List documents
- `POST /api/v1/accounts/{account_id}/navigator/documents` - Create document
- `GET /api/v1/accounts/{account_id}/navigator/documents/{id}` - Get document
- `DELETE /api/v1/accounts/{account_id}/navigator/documents/{id}` - Delete document

### Assistant Responses

- `GET /api/v1/accounts/{account_id}/navigator/assistant_responses` - List responses
- `POST /api/v1/accounts/{account_id}/navigator/assistant_responses` - Create response
- `PUT /api/v1/accounts/{account_id}/navigator/assistant_responses/{id}` - Update response
- `DELETE /api/v1/accounts/{account_id}/navigator/assistant_responses/{id}` - Delete response

### Inboxes

- `GET /api/v1/accounts/{account_id}/navigator/assistants/{assistant_id}/inboxes` - List assigned inboxes
- `POST /api/v1/accounts/{account_id}/navigator/assistants/{assistant_id}/inboxes` - Assign inbox
- `DELETE /api/v1/accounts/{account_id}/navigator/assistants/{assistant_id}/inboxes/{inbox_id}` - Unassign inbox

## Integration

### Webhook Integration

You can integrate Navigator with webhooks to automatically respond to incoming messages:

```ruby
# Create a webhook integration
hook = account.hooks.create!(
  app_id: 'navigator',
  settings: {
    assistant_id: assistant.id
  },
  status: 'enabled'
)
```

### Custom Processing

You can also use Navigator programmatically:

```ruby
service = Navigator::Llm::AssistantChatService.new(assistant: assistant)
response = service.generate_response("Hello, how can you help me?")
```

## Configuration

### Assistant Configuration

The assistant's `config` field can include:

```json
{
  "product_name": "Your Product",
  "temperature": 0.7,
  "max_tokens": 1000,
  "system_prompt": "Custom system prompt"
}
```

### Usage Limits

Navigator uses a simple limit system:

- Documents: 100 per account (configurable)
- Responses: Unlimited
- API calls: Based on your OpenAI plan

## Differences from Navigator

- **Simplified Architecture**: No complex tool registry or copilot features
- **No Premium Requirements**: Available in all Chatwoot installations
- **Basic Limits**: Simple usage limits instead of complex billing integration
- **Focused Features**: Core AI conversation and knowledge base features only

## Development

### Running Tests

```bash
rspec spec/controllers/api/v1/accounts/navigator/
rspec spec/models/navigator/
```

### Adding New Features

1. Create models in `app/models/navigator/`
2. Add controllers in `app/controllers/api/v1/accounts/navigator/`
3. Create services in `app/services/navigator/`
4. Add tests in `spec/`

## Troubleshooting

### Common Issues

1. **Vector Extension Error**: Ensure PostgreSQL has the `vector` extension enabled
2. **OpenAI API Errors**: Check your API key and model configuration
3. **Migration Errors**: Run `rails db:migrate` to create required tables

### Logs

Check the Rails logs for Navigator-related messages:

```bash
tail -f log/development.log | grep Navigator
```

## Contributing

When contributing to Navigator:

1. Follow the existing code patterns
2. Add comprehensive tests
3. Update this documentation
4. Ensure backward compatibility

## License

Navigator is part of Chatwoot and follows the same license terms. 