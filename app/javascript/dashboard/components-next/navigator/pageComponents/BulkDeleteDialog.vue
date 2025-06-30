<script setup>
import { ref } from 'vue';
import { useI18n } from 'vue-i18n';
import { useStore } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';

import Dialog from 'dashboard/components-next/dialog/Dialog.vue';
import Button from 'dashboard/components-next/button/Button.vue';

const props = defineProps({
  selectedItems: {
    type: Array,
    required: true,
  },
  type: {
    type: String,
    required: true,
    validator: value => ['response', 'document'].includes(value),
  },
});

const emit = defineEmits(['close', 'delete-success']);

const { t } = useI18n();
const store = useStore();

const dialogRef = ref(null);
const isDeleting = ref(false);

const handleDelete = async () => {
  try {
    isDeleting.value = true;
    
    // Delete each selected item
    for (const item of props.selectedItems) {
      await store.dispatch(`navigator${props.type.charAt(0).toUpperCase() + props.type.slice(1)}s/delete`, item.id);
    }
    
    useAlert(t(`NAVIGATOR.${props.type.toUpperCase()}S.BULK_DELETE.SUCCESS_MESSAGE`));
    dialogRef.value.close();
    emit('delete-success');
  } catch (error) {
    const errorMessage = error?.message || t(`NAVIGATOR.${props.type.toUpperCase()}S.BULK_DELETE.ERROR_MESSAGE`);
    useAlert(errorMessage);
  } finally {
    isDeleting.value = false;
  }
};

const handleClose = () => {
  emit('close');
};
</script>

<template>
  <Dialog
    ref="dialogRef"
    type="delete"
    :title="t(`NAVIGATOR.${type.toUpperCase()}S.BULK_DELETE.TITLE`)"
    :description="t(`NAVIGATOR.${type.toUpperCase()}S.BULK_DELETE.DESCRIPTION`, { count: selectedItems.length })"
    :show-cancel-button="true"
    :show-confirm-button="false"
    @close="handleClose"
  >
    <div class="flex flex-col gap-4">
      <div class="text-sm text-n-slate-11">
        {{ t(`NAVIGATOR.${type.toUpperCase()}S.BULK_DELETE.WARNING`) }}
      </div>
      
      <div class="flex items-center justify-end gap-3">
        <Button
          type="button"
          variant="faded"
          color="slate"
          :label="t('NAVIGATOR.FORM.CANCEL')"
          @click="handleClose"
        />
        <Button
          type="button"
          color="red"
          :label="t(`NAVIGATOR.${type.toUpperCase()}S.BULK_DELETE.CONFIRM`)"
          :is-loading="isDeleting"
          :disabled="isDeleting"
          @click="handleDelete"
        />
      </div>
    </div>
  </Dialog>
</template> 