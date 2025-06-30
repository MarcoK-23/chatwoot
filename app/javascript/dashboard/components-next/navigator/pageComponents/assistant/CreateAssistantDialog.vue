<script setup>
import { ref, computed } from 'vue';
import { useStore } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';

import Dialog from 'dashboard/components-next/dialog/Dialog.vue';
import AssistantForm from 'dashboard/components-next/captain/pageComponents/assistant/AssistantForm.vue';

const props = defineProps({
  selectedAssistant: {
    type: Object,
    default: () => ({}),
  },
  mode: {
    type: String,
    default: 'create',
    validator: value => ['create', 'edit'].includes(value),
  },
});
const emit = defineEmits(['close', 'submit']);
const { t } = useI18n();
const store = useStore();

const dialogRef = ref(null);
const assistantForm = ref(null);

const updateAssistant = assistantDetails =>
  store.dispatch('navigatorAssistants/update', {
    id: props.selectedAssistant.id,
    ...assistantDetails,
  });

const i18nKey = computed(
  () => `NAVIGATOR.ASSISTANTS.${props.mode.toUpperCase()}`
);

const createAssistant = assistantDetails =>
  store.dispatch('navigatorAssistants/create', assistantDetails);

const handleSubmit = async updatedAssistant => {
  try {
    if (props.mode === 'edit') {
      await updateAssistant(updatedAssistant);
    } else {
      await createAssistant(updatedAssistant);
    }
    useAlert(t(`${i18nKey.value}.SUCCESS_MESSAGE`));
    dialogRef.value.close();
    emit('submit');
  } catch (error) {
    const errorMessage = error?.message || t(`${i18nKey.value}.ERROR_MESSAGE`);
    useAlert(errorMessage);
  }
};

const handleClose = () => {
  emit('close');
};

const handleCancel = () => {
  dialogRef.value.close();
};

defineExpose({ dialogRef });
</script>

<template>
  <Dialog
    ref="dialogRef"
    type="edit"
    :title="t(`${i18nKey}.TITLE`)"
    :description="t('NAVIGATOR.ASSISTANTS.FORM_DESCRIPTION')"
    :show-cancel-button="false"
    :show-confirm-button="false"
    overflow-y-auto
    @close="handleClose"
  >
    <AssistantForm
      ref="assistantForm"
      :mode="mode"
      :assistant="selectedAssistant"
      @submit="handleSubmit"
      @cancel="handleCancel"
    />
    <template #footer />
  </Dialog>
</template> 