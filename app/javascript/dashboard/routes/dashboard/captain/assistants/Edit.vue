<script setup>
import { computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useStore } from 'dashboard/composables/store';
import { useMapGetter } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';
import PageLayout from 'dashboard/components-next/navigator/PageLayout.vue';
import EditAssistantForm from '../../../../components-next/navigator/pageComponents/assistant/EditAssistantForm.vue';
import AssistantPlayground from 'dashboard/components-next/navigator/assistant/AssistantPlayground.vue';

const route = useRoute();
const store = useStore();
const { t } = useI18n();
const assistantId = route.params.assistantId;
const uiFlags = useMapGetter('navigatorAssistants/getUIFlags');
const isFetching = computed(() => uiFlags.value.fetchingItem);
const assistant = computed(() =>
  store.getters['navigatorAssistants/getRecord'](Number(assistantId))
);

const isAssistantAvailable = computed(() => !!assistant.value?.id);

const handleSubmit = async updatedAssistant => {
  try {
    await store.dispatch('navigatorAssistants/update', {
      id: assistantId,
      ...updatedAssistant,
    });
    useAlert(t('NAVIGATOR.ASSISTANTS.EDIT.SUCCESS_MESSAGE'));
  } catch (error) {
    const errorMessage =
      error?.message || t('NAVIGATOR.ASSISTANTS.EDIT.ERROR_MESSAGE');
    useAlert(errorMessage);
  }
};

onMounted(() => {
  if (!isAssistantAvailable.value) {
    store.dispatch('navigatorAssistants/show', assistantId);
  }
});
</script>

<template>
  <PageLayout
    :header-title="assistant?.name"
    :show-pagination-footer="false"
    :is-fetching="isFetching"
    :show-know-more="false"
    :back-url="{ name: 'navigator_assistants_index' }"
  >
    <template #body>
      <div v-if="!isAssistantAvailable">
        {{ t('NAVIGATOR.ASSISTANTS.EDIT.NOT_FOUND') }}
      </div>
      <div v-else class="flex gap-4 h-full">
        <div class="flex-1 lg:overflow-auto pr-4 h-full md:h-auto">
          <EditAssistantForm
            :assistant="assistant"
            mode="edit"
            @submit="handleSubmit"
          />
        </div>
        <div class="w-[400px] hidden lg:block h-full">
          <AssistantPlayground :assistant-id="Number(assistantId)" />
        </div>
      </div>
    </template>
  </PageLayout>
</template>
