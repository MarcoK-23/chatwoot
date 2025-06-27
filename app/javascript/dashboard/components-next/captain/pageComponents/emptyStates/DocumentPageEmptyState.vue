<script setup>
import EmptyStateLayout from 'dashboard/components-next/EmptyStateLayout.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import DocumentCard from 'dashboard/components-next/navigator/assistant/DocumentCard.vue';
import FeatureSpotlight from 'dashboard/components-next/feature-spotlight/FeatureSpotlight.vue';
import { documentsList } from 'dashboard/components-next/navigator/pageComponents/emptyStates/navigatorEmptyStateContent.js';

const emit = defineEmits(['click']);

const onClick = () => {
  emit('click');
};
</script>

<template>
  <FeatureSpotlight
    :title="$t('NAVIGATOR.DOCUMENTS.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
    :note="$t('NAVIGATOR.DOCUMENTS.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
    fallback-thumbnail="/assets/images/dashboard/navigator/document-light.svg"
    fallback-thumbnail-dark="/assets/images/dashboard/navigator/document-dark.svg"
    learn-more-url="https://chwt.app/navigator-document"
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
          v-for="(document, index) in documentsList.slice(0, 5)"
          :id="document.id"
          :key="`document-${index}`"
          :name="document.name"
          :assistant="document.assistant"
          :external-link="document.external_link"
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
