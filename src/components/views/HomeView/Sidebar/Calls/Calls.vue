<script setup lang="ts">
import type { ICall } from "@src/types";
import { Ref, ref } from "vue";

import useStore from "@src/store/store";

import { PlusCircleIcon } from "@heroicons/vue/24/outline";
import CallInfoModal from "@src/components/shared/modals/CallInfoModal/CallInfoModal.vue";
import DialModal from "@src/components/shared/modals/DialModal/DialModal.vue";
import NoCalls from "@src/components/states/empty-states/NoCalls.vue";
import Circle2Lines from "@src/components/states/loading-states/Circle2Lines.vue";
import IconButton from "@src/components/ui/inputs/IconButton.vue";
import ExpandTransition from "@src/components/ui/transitions/ExpandTransition.vue";
import Call from "@src/components/views/HomeView/Sidebar/Calls/Call.vue";
import CallList from "@src/components/views/HomeView/Sidebar/Calls/CallList.vue";
import SidebarHeader from "@src/components/views/HomeView/Sidebar/SidebarHeader.vue";

const store = useStore();

const openDialModal = ref(false);

const selectedCall: Ref<ICall | null> = ref(null);
const openInfoModal = ref(false);
// (event) opens the voice call info modal
const handleOpenInfoModal = (call: ICall) => {
  openInfoModal.value = true;
  selectedCall.value = call;
};
</script>

<template>
  <div>
    <SidebarHeader>
      <!--title-->
      <template v-slot:title>Voice Calls</template>

      <!--side actions-->
      <template v-slot:actions>
        <IconButton
          @click="openDialModal = true"
          class="ic-btn-ghost-primary w-7 h-7"
          title="initiate call"
          aria-label="initiate call"
        >
          <PlusCircleIcon class="w-[1.25rem] h-[1.25rem]" />
        </IconButton>
      </template>
    </SidebarHeader>

    <!--content-->
    <div
      ref="contactContainer"
      class="w-full h-full scroll-smooth scrollbar-hidden"
      style="overflow-x: visible; overflow-y: scroll"
    >
      <Circle2Lines
        v-if="store.status === 'loading' || store.delayLoading"
        v-for="item in 6"
      />

      <div v-else>
        <ExpandTransition>
          <div
            class="max-h-50"
            v-if="store.callMinimized && store.activeCall"
          >
            <Call
              v-if="store.activeCall"
              :call="store.activeCall"
              :open-voice-call-modal="() => (store.openVoiceCall = true)"
              :end-call="
                () => {
                  store.activeCall = undefined;
                  store.callMinimized = false;
                }
              "
              active
            />
          </div>
        </ExpandTransition>

        <CallList
          v-if="(store.calls as ICall[])?.length > 0"
          delay-loading="chat.delayLoading"
          :chat-status="store.status"
          :open-info-modal="handleOpenInfoModal"
          :calls="<ICall[]>store.calls"
        />

        <NoCalls v-else />
      </div>
    </div>

    <!--call info modal-->
    <CallInfoModal
      :open="openInfoModal"
      :close-modal="() => (openInfoModal = false)"
      :call="<ICall>selectedCall"
    />

    <!--start call modal-->
    <DialModal
      :open="openDialModal"
      :close-modal="() => (openDialModal = false)"
    />
  </div>
</template>
