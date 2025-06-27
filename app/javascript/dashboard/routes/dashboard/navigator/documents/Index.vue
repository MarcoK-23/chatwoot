<script setup>
import { computed, onMounted, ref, nextTick } from 'vue';
import { useMapGetter, useStore } from 'dashboard/composables/store';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';

import DeleteDialog from 'dashboard/components-next/navigator/pageComponents/DeleteDialog.vue';
import DocumentCard from 'dashboard/components-next/navigator/assistant/DocumentCard.vue';
import PageLayout from 'dashboard/components-next/navigator/PageLayout.vue';
import RelatedResponses from 'dashboard/components-next/navigator/pageComponents/document/RelatedResponses.vue';
import CreateDocumentDialog from 'dashboard/components-next/navigator/pageComponents/document/CreateDocumentDialog.vue';
import AssistantSelector from 'dashboard/components-next/navigator/pageComponents/AssistantSelector.vue';
import DocumentPageEmptyState from 'dashboard/components-next/navigator/pageComponents/emptyStates/DocumentPageEmptyState.vue';
import FeatureSpotlightPopover from 'dashboard/components-next/feature-spotlight/FeatureSpotlightPopover.vue';

const store = useStore();

const uiFlags = useMapGetter('navigatorDocuments/getUIFlags');
const documents = useMapGetter('navigatorDocuments/getRecords');
const assistants = useMapGetter('navigatorAssistants/getRecords');
const isFetching = computed(() => uiFlags.value.fetchingList);
const documentsMeta = useMapGetter('navigatorDocuments/getMeta');
const selectedAssistant = ref('all');

const selectedDocument = ref(null);
const deleteDocumentDialog = ref(null);

const handleDelete = () => {
  deleteDocumentDialog.value.dialogRef.open();
};

const showRelatedResponses = ref(false);
const showCreateDialog = ref(false);
const createDocumentDialog = ref(null);
const relationQuestionDialog = ref(null);

const handleCreate = () => {
  showCreateDialog.value = true;
  nextTick(() => createDocumentDialog.value.dialogRef.open());
};

const handleDeleteSuccess = () => {
  selectedDocument.value = null;
  store.dispatch('navigatorDocuments/get', {
    assistantId: selectedAssistant.value === 'all' ? null : selectedAssistant.value,
  });
};

const onPageChange = page => {
  store.dispatch('navigatorDocuments/get', {
    page,
    assistantId: selectedAssistant.value === 'all' ? null : selectedAssistant.value,
  });
};

const handleAssistantFilterChange = assistantId => {
  selectedAssistant.value = assistantId;
  store.dispatch('navigatorDocuments/get', {
    assistantId: assistantId === 'all' ? null : assistantId,
  });
};

onMounted(() => {
  store.dispatch('navigatorAssistants/get');
  store.dispatch('navigatorDocuments/get');
});
</script>

<template>
  <PageLayout
    :total-count="documentsMeta.totalCount"
    :current-page="documentsMeta.page"
    :button-policy="['administrator']"
    :header-title="$t('NAVIGATOR.DOCUMENTS.HEADER')"
    :button-label="$t('NAVIGATOR.DOCUMENTS.ADD_NEW')"
    :is-fetching="isFetching"
    :is-empty="!documents.length"
    :show-pagination-footer="!isFetching && !!documents.length"
    :feature-flag="FEATURE_FLAGS.NAVIGATOR"
    @update:current-page="onPageChange"
    @click="handleCreate"
  >
    <template #knowMore>
      <FeatureSpotlightPopover
        :button-label="$t('NAVIGATOR.HEADER_KNOW_MORE')"
        :title="$t('NAVIGATOR.DOCUMENTS.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
        :note="$t('NAVIGATOR.DOCUMENTS.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
        fallback-thumbnail="/assets/images/dashboard/navigator/documents-popover-light.svg"
        fallback-thumbnail-dark="/assets/images/dashboard/navigator/documents-popover-dark.svg"
        learn-more-url="https://chwt.app/navigator-documents"
      />
    </template>

    <template #emptyState>
      <DocumentPageEmptyState @click="handleCreate" />
    </template>

    <template #controls>
      <div
        v-if="assistants.length > 0"
        class="mb-4 -mt-3 flex justify-between items-center"
      >
        <AssistantSelector
          :assistant-id="selectedAssistant"
          @update="handleAssistantFilterChange"
        />
      </div>
    </template>

    <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      <DocumentCard
        v-for="document in documents"
        :key="document.id"
        :document="document"
        :is-selected="selectedDocument?.id === document.id"
        @select="selectedDocument = document"
        @delete="handleDelete"
        @show-related-responses="showRelatedResponses = true"
      />
    </div>

    <CreateDocumentDialog
      ref="createDocumentDialog"
      @close="createDocumentDialog.dialogRef.close()"
      @submit="
        createDocumentDialog.dialogRef.close();
        store.dispatch('navigatorDocuments/get', {
          assistantId: selectedAssistant === 'all' ? null : selectedAssistant,
        });
      "
    />

    <DeleteDialog
      ref="deleteDocumentDialog"
      type="document"
      :entity="selectedDocument"
      @delete-success="handleDeleteSuccess"
    />

    <RelatedResponses
      v-if="showRelatedResponses && selectedDocument"
      :navigator-document="selectedDocument"
      @close="showRelatedResponses = false"
    />
  </PageLayout>
</template> 