require 'openai'

class Navigator::Llm::EmbeddingService < Llm::BaseOpenAiService
  def get_embedding(text)
    response = @client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: text
      }
    )
    response.dig('data', 0, 'embedding')
  end
end 