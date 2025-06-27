class Navigator::Llm::UpdateEmbeddingJob < ApplicationJob
  queue_as :low

  def perform(record, content)
    embedding = Navigator::Llm::EmbeddingService.new.get_embedding(content)
    record.update!(embedding: embedding)
  end
end
