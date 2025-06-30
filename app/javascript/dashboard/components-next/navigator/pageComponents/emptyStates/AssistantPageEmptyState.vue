<script setup>
import EmptyStateLayout from 'dashboard/components-next/EmptyStateLayout.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import FeatureSpotlight from 'dashboard/components-next/feature-spotlight/FeatureSpotlight.vue';

const emit = defineEmits(['click']);

const onClick = () => {
  emit('click');
};
</script>

<template>
  <FeatureSpotlight
    :title="$t('NAVIGATOR.ASSISTANTS.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
    :note="$t('NAVIGATOR.ASSISTANTS.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
    fallback-thumbnail="/assets/images/dashboard/navigator/assistants-popover-light.svg"
    fallback-thumbnail-dark="/assets/images/dashboard/navigator/assistants-popover-dark.svg"
    learn-more-url="https://chwt.app/navigator-assistants"
    class="mb-8"
  />
  <EmptyStateLayout
    :title="$t('NAVIGATOR.ASSISTANTS.EMPTY_STATE.TITLE')"
    :subtitle="$t('NAVIGATOR.ASSISTANTS.EMPTY_STATE.SUBTITLE')"
    :action-perms="['administrator']"
  >
    <template #actions>
      <Button
        :label="$t('NAVIGATOR.ASSISTANTS.ADD_NEW')"
        icon="i-lucide-plus"
        @click="onClick"
      />
    </template>
  </EmptyStateLayout>
</template> 