<script setup>
import EmptyStateLayout from 'dashboard/components-next/EmptyStateLayout.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import ResponseCard from 'dashboard/components-next/navigator/pageComponents/ResponseCard.vue';
import FeatureSpotlight from 'dashboard/components-next/feature-spotlight/FeatureSpotlight.vue';

const emit = defineEmits(['click']);

const onClick = () => {
  emit('click');
};

// Sample responses for empty state preview
const responsesList = [
  {
    id: 1,
    question: 'How do I reset my password?',
    answer: 'To reset your password, go to the login page and click on "Forgot Password". You will receive an email with instructions to create a new password.',
    status: 'approved',
    assistant: { name: 'Support Assistant' },
    created_at: Date.now() - 86400000, // 1 day ago
  },
  {
    id: 2,
    question: 'What are your business hours?',
    answer: 'Our customer support team is available Monday through Friday, 9 AM to 6 PM EST. For urgent matters outside these hours, please use our emergency contact form.',
    status: 'approved',
    assistant: { name: 'Support Assistant' },
    created_at: Date.now() - 172800000, // 2 days ago
  },
  {
    id: 3,
    question: 'How can I update my billing information?',
    answer: 'You can update your billing information by logging into your account and navigating to the Billing section. There you can modify your payment method and billing address.',
    status: 'pending',
    assistant: { name: 'Support Assistant' },
    created_at: Date.now() - 259200000, // 3 days ago
  },
];
</script>

<template>
  <FeatureSpotlight
    :title="$t('NAVIGATOR.RESPONSES.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
    :note="$t('NAVIGATOR.RESPONSES.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
    fallback-thumbnail="/assets/images/dashboard/navigator/faqs-popover-light.svg"
    fallback-thumbnail-dark="/assets/images/dashboard/navigator/faqs-popover-dark.svg"
    learn-more-url="https://chwt.app/navigator-faq"
    class="mb-8"
  />
  <EmptyStateLayout
    :title="$t('NAVIGATOR.RESPONSES.EMPTY_STATE.TITLE')"
    :subtitle="$t('NAVIGATOR.RESPONSES.EMPTY_STATE.SUBTITLE')"
    :action-perms="['administrator']"
  >
    <template #empty-state-item>
      <div class="grid grid-cols-1 gap-4 p-px overflow-hidden">
        <ResponseCard
          v-for="(response, index) in responsesList.slice(0, 3)"
          :id="response.id"
          :key="`response-${index}`"
          :question="response.question"
          :answer="response.answer"
          :status="response.status"
          :assistant="response.assistant"
          :created-at="response.created_at"
          :updated-at="response.created_at"
        />
      </div>
    </template>
    <template #actions>
      <Button
        :label="$t('NAVIGATOR.RESPONSES.ADD_NEW')"
        icon="i-lucide-plus"
        @click="onClick"
      />
    </template>
  </EmptyStateLayout>
</template> 