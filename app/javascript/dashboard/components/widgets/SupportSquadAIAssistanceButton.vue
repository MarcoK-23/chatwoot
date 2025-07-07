<script>
import { mapGetters } from 'vuex';
import { useUISettings } from 'dashboard/composables/useUISettings';
import { useSupportSquadAI } from 'dashboard/composables/useSupportSquadAI';
import { CMD_AI_ASSIST } from 'shared/constants/commandBar';
import { emitter } from 'shared/helpers/mitt';
import SupportSquadAIAssistanceCTAButton from './AIAssistanceCTAButton.vue';
import SupportSquadAICTAModal from './SupportSquadAICTAModal.vue';
import SupportSquadAIAssistanceModal from './SupportSquadAIAssistanceModal.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';

export default {
  components: {
    SupportSquadAIAssistanceCTAButton,
    SupportSquadAICTAModal,
    SupportSquadAIAssistanceModal,
    NextButton,
  },
  emits: ['replaceText'],
  setup() {
    const { uiSettings, updateUISettings } = useUISettings();
    const { isSupportSquadAIIntegrationEnabled, recordAnalytics } = useSupportSquadAI();
    return {
      uiSettings,
      updateUISettings,
      isSupportSquadAIIntegrationEnabled,
      recordAnalytics,
    };
  },
  data: () => ({
    showSupportSquadAIAssistanceModal: false,
    showSupportSquadAICtaModal: false,
    aiOption: '',
  }),
  computed: {
    ...mapGetters({
      isAChatwootInstance: 'globalConfig/isAChatwootInstance',
    }),
    isSupportSquadAICTAModalDismissed() {
      return this.uiSettings.is_support_squad_ai_cta_modal_dismissed;
    },
    // Display a AI CTA button for admins if the AI integration has not been added yet and the AI assistance modal has not been dismissed.
    shouldShowSupportSquadAIAssistCTAButtonForAdmin() {
      return (
        this.isAdmin &&
        !this.isSupportSquadAIIntegrationEnabled &&
        !this.isSupportSquadAICTAModalDismissed &&
        this.isAChatwootInstance
      );
    },
    // Display a AI CTA button for agents and other admins who have not yet opened the AI assistance modal.
    shouldShowSupportSquadAIAssistCTAButton() {
      return this.isSupportSquadAIIntegrationEnabled && !this.isSupportSquadAICTAModalDismissed;
    },
  },

  mounted() {
    emitter.on(CMD_AI_ASSIST, this.onSupportSquadAIAssist);
    this.initializeMessage(this.draftMessage);
  },

  methods: {
    hideSupportSquadAIAssistanceModal() {
      this.recordAnalytics('DISMISS_AI_SUGGESTION', {
        aiOption: this.aiOption,
      });
      this.showSupportSquadAIAssistanceModal = false;
    },
    openSupportSquadAIAssist() {
      // Dismiss the CTA modal if it is not dismissed
      if (!this.isSupportSquadAICTAModalDismissed) {
        this.updateUISettings({
          is_support_squad_ai_cta_modal_dismissed: true,
        });
      }
      this.initializeMessage(this.draftMessage);
      const ninja = document.querySelector('ninja-keys');
      ninja.open({ parent: 'ai_assist' });
    },
    hideSupportSquadAICtaModal() {
      this.showSupportSquadAICtaModal = false;
    },
    openSupportSquadAICta() {
      this.showSupportSquadAICtaModal = true;
    },
    onSupportSquadAIAssist(option) {
      this.aiOption = option;
      this.showSupportSquadAIAssistanceModal = true;
    },
    insertText(message) {
      this.$emit('replaceText', message);
    },
  },
};
</script>

<template>
  <div>
    <div v-if="isSupportSquadAIIntegrationEnabled" class="relative">
      <SupportSquadAIAssistanceCTAButton
        v-if="shouldShowSupportSquadAIAssistCTAButton"
        @open="openSupportSquadAIAssist"
      />
      <NextButton
        v-else
        v-tooltip.top-end="$t('INTEGRATION_SETTINGS.SUPPORT_SQUAD_AI.AI_ASSIST')"
        icon="i-ph-magic-wand"
        slate
        faded
        sm
        @click="openSupportSquadAIAssist"
      />
      <woot-modal
        v-model:show="showSupportSquadAIAssistanceModal"
        :on-close="hideSupportSquadAIAssistanceModal"
      >
        <SupportSquadAIAssistanceModal
          :ai-option="aiOption"
          @apply-text="insertText"
          @close="hideSupportSquadAIAssistanceModal"
        />
      </woot-modal>
    </div>
    <div v-else-if="shouldShowSupportSquadAIAssistCTAButtonForAdmin" class="relative">
      <SupportSquadAIAssistanceCTAButton @click="openSupportSquadAICta" />
      <woot-modal v-model:show="showSupportSquadAICtaModal" :on-close="hideSupportSquadAICtaModal">
        <SupportSquadAICTAModal @close="hideSupportSquadAICtaModal" />
      </woot-modal>
    </div>
  </div>
</template> 