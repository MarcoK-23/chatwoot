<script setup>
import { computed, onMounted, ref, nextTick } from 'vue';
import { useMapGetter, useStore } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';
import { OnClickOutside } from '@vueuse/components';
import { useRouter } from 'vue-router';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';

import Button from 'dashboard/components-next/button/Button.vue';
import Checkbox from 'dashboard/components-next/checkbox/Checkbox.vue';
import DropdownMenu from 'dashboard/components-next/dropdown-menu/DropdownMenu.vue';
import DeleteDialog from 'dashboard/components-next/navigator/pageComponents/DeleteDialog.vue';
import BulkDeleteDialog from 'dashboard/components-next/navigator/pageComponents/BulkDeleteDialog.vue';
import PageLayout from 'dashboard/components-next/navigator/pageComponents/PageLayout.vue';
import AssistantSelector from 'dashboard/components-next/navigator/pageComponents/AssistantSelector.vue';
import ResponseCard from 'dashboard/components-next/navigator/pageComponents/ResponseCard.vue';
import CreateResponseDialog from 'dashboard/components-next/navigator/pageComponents/response/CreateResponseDialog.vue';
import ResponsePageEmptyState from 'dashboard/components-next/navigator/pageComponents/emptyStates/ResponsePageEmptyState.vue';
import FeatureSpotlightPopover from 'dashboard/components-next/feature-spotlight/FeatureSpotlightPopover.vue';

const router = useRouter();
const store = useStore();
const uiFlags = useMapGetter('navigatorResponses/getUIFlags');
const assistants = useMapGetter('navigatorAssistants/getRecords');
const responseMeta = useMapGetter('navigatorResponses/getMeta');
const responses = useMapGetter('navigatorResponses/getRecords');
const isFetching = computed(() => uiFlags.value.fetchingList);

const selectedResponse = ref(null);
const deleteDialog = ref(null);
const bulkDeleteDialog = ref(null);

const selectedStatus = ref('all');
const selectedAssistant = ref('all');
const dialogType = ref('');
const { t } = useI18n();

const createDialog = ref(null);

const isStatusFilterOpen = ref(false);
const shouldShowDropdown = computed(() => {
  if (assistants.value.length === 0) return false;

  return !isFetching.value;
});

const statusOptions = computed(() =>
  ['all', 'pending', 'approved'].map(key => ({
    label: t(`NAVIGATOR.RESPONSES.STATUS.${key.toUpperCase()}`),
    value: key,
    action: 'filter',
  }))
);

const selectedStatusLabel = computed(() => {
  const status = statusOptions.value.find(
    option => option.value === selectedStatus.value
  );
  return t('NAVIGATOR.RESPONSES.FILTER.STATUS', {
    selected: status ? status.label : '',
  });
});

const handleDelete = () => {
  deleteDialog.value.dialogRef.open();
};

const handleAccept = async () => {
  try {
    await store.dispatch('navigatorResponses/update', {
      id: selectedResponse.value.id,
      status: 'approved',
    });
    useAlert(t(`NAVIGATOR.RESPONSES.EDIT.APPROVE_SUCCESS_MESSAGE`));
  } catch (error) {
    const errorMessage =
      error?.message || t(`NAVIGATOR.RESPONSES.EDIT.ERROR_MESSAGE`);
    useAlert(errorMessage);
  } finally {
    selectedResponse.value = null;
  }
};

const handleCreate = () => {
  dialogType.value = 'create';
  nextTick(() => createDialog.value.dialogRef.open());
};

const handleEdit = () => {
  dialogType.value = 'edit';
  nextTick(() => createDialog.value.dialogRef.open());
};

const handleDeleteSuccess = () => {
  selectedResponse.value = null;
  store.dispatch('navigatorResponses/get', {
    assistantId: selectedAssistant.value === 'all' ? null : selectedAssistant.value,
    status: selectedStatus.value === 'all' ? null : selectedStatus.value,
  });
};

const onPageChange = page => {
  store.dispatch('navigatorResponses/get', {
    page,
    assistantId: selectedAssistant.value === 'all' ? null : selectedAssistant.value,
    status: selectedStatus.value === 'all' ? null : selectedStatus.value,
  });
};

const handleStatusFilterChange = ({ value }) => {
  selectedStatus.value = value;
  store.dispatch('navigatorResponses/get', {
    assistantId: selectedAssistant.value === 'all' ? null : selectedAssistant.value,
    status: value === 'all' ? null : value,
  });
};

const handleAssistantFilterChange = assistantId => {
  selectedAssistant.value = assistantId;
  store.dispatch('navigatorResponses/get', {
    assistantId: assistantId === 'all' ? null : assistantId,
    status: selectedStatus.value === 'all' ? null : selectedStatus.value,
  });
};

const handleResponseAction = ({ action }) => {
  if (action === 'edit') {
    handleEdit();
  } else if (action === 'delete') {
    handleDelete();
  } else if (action === 'approve') {
    handleAccept();
  }
};

onMounted(() => {
  store.dispatch('navigatorAssistants/get');
  store.dispatch('navigatorResponses/get');
});
</script>

<template>
  <PageLayout
    :total-count="responseMeta.totalCount"
    :current-page="responseMeta.page"
    :button-policy="['administrator']"
    :header-title="$t('NAVIGATOR.RESPONSES.HEADER')"
    :button-label="$t('NAVIGATOR.RESPONSES.ADD_NEW')"
    :is-fetching="isFetching"
    :is-empty="!responses.length"
    :show-pagination-footer="!isFetching && !!responses.length"
    :feature-flag="FEATURE_FLAGS.NAVIGATOR"
    @update:current-page="onPageChange"
    @click="handleCreate"
  >
    <template #knowMore>
      <FeatureSpotlightPopover
        :button-label="$t('NAVIGATOR.HEADER_KNOW_MORE')"
        :title="$t('NAVIGATOR.RESPONSES.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
        :note="$t('NAVIGATOR.RESPONSES.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
        fallback-thumbnail="/assets/images/dashboard/navigator/faqs-popover-light.svg"
        fallback-thumbnail-dark="/assets/images/dashboard/navigator/faqs-popover-dark.svg"
        learn-more-url="https://chwt.app/navigator-faq"
      />
    </template>

    <template #emptyState>
      <ResponsePageEmptyState @click="handleCreate" />
    </template>

    <template #controls>
      <div
        v-if="shouldShowDropdown"
        class="mb-4 -mt-3 flex justify-between items-center"
      >
        <div class="flex gap-3">
          <OnClickOutside @trigger="isStatusFilterOpen = false">
            <Button
              :label="selectedStatusLabel"
              icon="i-lucide-chevron-down"
              size="sm"
              color="slate"
              trailing-icon
              class="max-w-48"
              @click="isStatusFilterOpen = !isStatusFilterOpen"
            />

            <DropdownMenu
              v-if="isStatusFilterOpen"
              :menu-items="statusOptions"
              class="mt-2"
              @action="handleStatusFilterChange"
            />
          </OnClickOutside>

          <AssistantSelector
            :assistant-id="selectedAssistant"
            @update="handleAssistantFilterChange"
          />
        </div>
      </div>
    </template>

    <div class="space-y-4">
      <ResponseCard
        v-for="response in responses"
        :key="response.id"
        :id="response.id"
        :question="response.question"
        :status="response.status"
        :answer="response.answer"
        :assistant="response.assistant"
        :created-at="response.created_at"
        :updated-at="response.updated_at"
        :is-selected="selectedResponse?.id === response.id"
        @select="selectedResponse = response"
        @action="handleResponseAction"
      />
    </div>

    <CreateResponseDialog
      ref="createDialog"
      :mode="dialogType"
      :response="selectedResponse"
      @close="createDialog.dialogRef.close()"
      @submit="
        createDialog.dialogRef.close();
        store.dispatch('navigatorResponses/get', {
          assistantId: selectedAssistant === 'all' ? null : selectedAssistant,
          status: selectedStatus === 'all' ? null : selectedStatus,
        });
      "
    />

    <DeleteDialog
      ref="deleteDialog"
      type="response"
      :entity="selectedResponse"
      @delete-success="handleDeleteSuccess"
    />
  </PageLayout>
</template> 