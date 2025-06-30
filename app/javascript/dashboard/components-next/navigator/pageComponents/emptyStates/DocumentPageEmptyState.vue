<script setup>
import EmptyStateLayout from 'dashboard/components-next/EmptyStateLayout.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import DocumentCard from 'dashboard/components-next/navigator/pageComponents/DocumentCard.vue';
import FeatureSpotlight from 'dashboard/components-next/feature-spotlight/FeatureSpotlight.vue';

const emit = defineEmits(['click']);

const onClick = () => {
  emit('click');
};

// Sample documents for empty state preview
const documentsList = [
  {
    id: 1,
    name: 'Product Manual',
    externalLink: 'https://docs.example.com/manual',
    assistant: { name: 'Support Assistant' },
    created_at: Date.now() - 86400000, // 1 day ago
  },
  {
    id: 2,
    name: 'API Documentation',
    externalLink: 'https://api.example.com/docs',
    assistant: { name: 'Support Assistant' },
    created_at: Date.now() - 172800000, // 2 days ago
  },
  {
    id: 3,
    name: 'Troubleshooting Guide',
    externalLink: 'https://help.example.com/troubleshooting',
    assistant: { name: 'Support Assistant' },
    created_at: Date.now() - 259200000, // 3 days ago
  },
];
</script>

<template>
  <FeatureSpotlight
    :title="$t('NAVIGATOR.DOCUMENTS.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
    :note="$t('NAVIGATOR.DOCUMENTS.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
    fallback-thumbnail="/assets/images/dashboard/navigator/documents-popover-light.svg"
    fallback-thumbnail-dark="/assets/images/dashboard/navigator/documents-popover-dark.svg"
    learn-more-url="https://chwt.app/navigator-documents"
    class="mb-8"
  />
  <EmptyStateLayout
    :title="$t('NAVIGATOR.DOCUMENTS.EMPTY_STATE.TITLE')"
    :subtitle="$t('NAVIGATOR.DOCUMENTS.EMPTY_STATE.SUBTITLE')"
    :action-perms="['administrator']"
  >
    <template #empty-state-item>
      <div class="grid grid-cols-1 gap-4 p-px overflow-hidden">
        <DocumentCard
          v-for="(document, index) in documentsList.slice(0, 3)"
          :id="document.id"
          :key="`document-${index}`"
          :name="document.name"
          :external-link="document.externalLink"
          :assistant="document.assistant"
          :created-at="document.created_at"
        />
      </div>
    </template>
    <template #actions>
      <Button
        :label="$t('NAVIGATOR.DOCUMENTS.ADD_NEW')"
        icon="i-lucide-plus"
        @click="onClick"
      />
    </template>
  </EmptyStateLayout>
</template> 