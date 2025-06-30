<script setup>
import { computed, onMounted, ref, nextTick, watch } from 'vue';
import { useMapGetter, useStore } from 'dashboard/composables/store';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';

import AssistantCard from 'dashboard/components-next/navigator/pageComponents/assistant/AssistantCard.vue';
import DeleteDialog from 'dashboard/components-next/navigator/pageComponents/DeleteDialog.vue';
import PageLayout from 'dashboard/components-next/navigator/pageComponents/PageLayout.vue';
import CreateAssistantDialog from 'dashboard/components-next/navigator/pageComponents/assistant/CreateAssistantDialog.vue';
import AssistantPageEmptyState from 'dashboard/components-next/navigator/pageComponents/emptyStates/AssistantPageEmptyState.vue';
import FeatureSpotlightPopover from 'dashboard/components-next/feature-spotlight/FeatureSpotlightPopover.vue';
import { useRouter } from 'vue-router';

const router = useRouter();

const store = useStore();
const dialogType = ref('');
const uiFlags = useMapGetter('navigatorAssistants/getUIFlags');
const assistants = useMapGetter('navigatorAssistants/getRecords');
const isFetching = computed(() => uiFlags.value.fetchingList);

const selectedAssistant = ref(null);
const deleteAssistantDialog = ref(null);

const handleDelete = () => {
  deleteAssistantDialog.value.dialogRef.open();
};

const createAssistantDialog = ref(null);

const handleCreate = () => {
  dialogType.value = 'create';
  nextTick(() => createAssistantDialog.value.dialogRef.open());
};

const handleEdit = () => {
  router.push({
    name: 'navigator_assistants_edit',
    params: { assistantId: selectedAssistant.value.id },
  });
};

const handleDeleteSuccess = () => {
  selectedAssistant.value = null;
  store.dispatch('navigatorAssistants/get');
};

const onPageChange = page => {
  store.dispatch('navigatorAssistants/get', { page });
};

const handleCreateDialogClose = () => {
  dialogType.value = '';
};

// Log assistant times for debugging
watch(assistants, (newVal) => {
  newVal.forEach(a => {
    console.log('Assistant times:', a.updated_at, a.created_at);
  });
});

onMounted(() => {
  store.dispatch('navigatorAssistants/get');
});
</script>

<template>
  <PageLayout
    :total-count="0"
    :current-page="1"
    :button-policy="['administrator']"
    :header-title="$t('NAVIGATOR.ASSISTANTS.HEADER')"
    :button-label="$t('NAVIGATOR.ASSISTANTS.ADD_NEW')"
    :is-fetching="isFetching"
    :is-empty="!assistants.length"
    :show-pagination-footer="!isFetching && !!assistants.length"
    :feature-flag="FEATURE_FLAGS.NAVIGATOR"
    @update:current-page="onPageChange"
    @click="handleCreate"
  >
    <template #knowMore>
      <FeatureSpotlightPopover
        :button-label="$t('NAVIGATOR.HEADER_KNOW_MORE')"
        :title="$t('NAVIGATOR.ASSISTANTS.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
        :note="$t('NAVIGATOR.ASSISTANTS.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
        fallback-thumbnail="/assets/images/dashboard/navigator/assistants-popover-light.svg"
        fallback-thumbnail-dark="/assets/images/dashboard/navigator/assistants-popover-dark.svg"
        learn-more-url="https://chwt.app/navigator-assistants"
      />
    </template>

    <template #emptyState>
      <AssistantPageEmptyState @click="handleCreate" />
    </template>

    <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      <AssistantCard
        v-for="assistant in assistants"
        :key="assistant.id"
        :id="assistant.id"
        :name="assistant.name || ''"
        :description="assistant.description || ''"
        :updatedAt="assistant.updated_at || assistant.created_at || Date.now()"
        :is-selected="selectedAssistant?.id === assistant.id"
        @select="selectedAssistant = assistant"
        @edit="handleEdit"
        @delete="handleDelete"
      />
    </div>

    <CreateAssistantDialog
      ref="createAssistantDialog"
      :mode="dialogType"
      @close="handleCreateDialogClose"
      @submit="
        dialogType = '';
        store.dispatch('navigatorAssistants/get');
      "
    />

    <DeleteDialog
      ref="deleteAssistantDialog"
      type="assistant"
      :entity="selectedAssistant"
      @delete-success="handleDeleteSuccess"
    />
  </PageLayout>
</template> 