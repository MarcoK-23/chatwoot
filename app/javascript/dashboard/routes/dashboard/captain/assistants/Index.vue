<script setup>
import { computed, onMounted, ref, nextTick } from 'vue';
import { useMapGetter, useStore } from 'dashboard/composables/store';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';

import AssistantCard from 'dashboard/components-next/navigator/assistant/AssistantCard.vue';
import DeleteDialog from 'dashboard/components-next/navigator/pageComponents/DeleteDialog.vue';
import PageLayout from 'dashboard/components-next/navigator/PageLayout.vue';
import NavigatorPaywall from 'dashboard/components-next/navigator/pageComponents/Paywall.vue';
import CreateAssistantDialog from 'dashboard/components-next/navigator/pageComponents/assistant/CreateAssistantDialog.vue';
import AssistantPageEmptyState from 'dashboard/components-next/navigator/pageComponents/emptyStates/AssistantPageEmptyState.vue';
import FeatureSpotlightPopover from 'dashboard/components-next/feature-spotlight/FeatureSpotlightPopover.vue';
import LimitBanner from 'dashboard/components-next/navigator/pageComponents/response/LimitBanner.vue';
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

const handleViewConnectedInboxes = () => {
  router.push({
    name: 'navigator_assistants_inboxes_index',
    params: { assistantId: selectedAssistant.value.id },
  });
};

const handleAction = ({ action, id }) => {
  selectedAssistant.value = assistants.value.find(
    assistant => id === assistant.id
  );
  nextTick(() => {
    if (action === 'delete') {
      handleDelete();
    }
    if (action === 'edit') {
      handleEdit();
    }
    if (action === 'viewConnectedInboxes') {
      handleViewConnectedInboxes();
    }
  });
};

const handleCreateClose = () => {
  dialogType.value = '';
  selectedAssistant.value = null;
};

onMounted(() => store.dispatch('navigatorAssistants/get'));
</script>

<template>
  <PageLayout
    :header-title="$t('NAVIGATOR.ASSISTANTS.HEADER')"
    :button-label="$t('NAVIGATOR.ASSISTANTS.ADD_NEW')"
    :button-policy="['administrator']"
    :show-pagination-footer="false"
    :is-fetching="isFetching"
    :is-empty="!assistants.length"
    :feature-flag="FEATURE_FLAGS.NAVIGATOR"
    @click="handleCreate"
  >
    <template #knowMore>
      <FeatureSpotlightPopover
        :button-label="$t('NAVIGATOR.HEADER_KNOW_MORE')"
        :title="$t('NAVIGATOR.ASSISTANTS.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
        :note="$t('NAVIGATOR.ASSISTANTS.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
        fallback-thumbnail="/assets/images/dashboard/navigator/assistant-popover-light.svg"
        fallback-thumbnail-dark="/assets/images/dashboard/navigator/assistant-popover-dark.svg"
        learn-more-url="https://chwt.app/navigator-assistant"
      />
    </template>
    <template #emptyState>
      <AssistantPageEmptyState @click="handleCreate" />
    </template>

    <template #paywall>
      <NavigatorPaywall />
    </template>

    <template #body>
      <LimitBanner class="mb-5" />

      <div class="flex flex-col gap-4">
        <AssistantCard
          v-for="assistant in assistants"
          :id="assistant.id"
          :key="assistant.id"
          :name="assistant.name"
          :description="assistant.description"
          :updated-at="assistant.updated_at || assistant.created_at"
          :created-at="assistant.created_at"
          @action="handleAction"
        />
      </div>
    </template>

    <DeleteDialog
      v-if="selectedAssistant"
      ref="deleteAssistantDialog"
      :entity="selectedAssistant"
      type="Assistants"
    />

    <CreateAssistantDialog
      v-if="dialogType"
      ref="createAssistantDialog"
      :type="dialogType"
      :selected-assistant="selectedAssistant"
      @close="handleCreateClose"
    />
  </PageLayout>
</template>
