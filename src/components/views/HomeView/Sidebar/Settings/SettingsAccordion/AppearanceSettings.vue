<script setup lang="ts">
import useStore from "@src/store/store";

import AccordionButton from "@src/components/ui/data-display/AccordionButton.vue";
import Collapse from "@src/components/ui/utils/Collapse.vue";
import SettingsSwitch from "@src/components/views/HomeView/Sidebar/Settings/SettingsAccordion/SettingsSwitch.vue";

const props = defineProps<{
  collapsed: boolean;
  handleToggle: () => void;
}>();

const store = useStore();
</script>

<template>
  <!--appearance settings-->
  <AccordionButton
    id="appearance-settings-toggler"
    class="w-full flex px-5 py-6 mb-3 rounded focus:outline-none"
    :collapsed="props.collapsed"
    chevron
    aria-controls="appearance-settings-collapse"
    @click="props.handleToggle()"
  >
    <p class="heading-2 text-black/70 dark:text-white/70 mb-4">Appearance</p>
    <p class="body-2 text-black/70 dark:text-white/70">
      Customize the look and feel
    </p>
  </AccordionButton>

  <Collapse id="appearance-settings-collapse" :collapsed="props.collapsed">
    <SettingsSwitch
      title="Dark Mode"
      description="Apply a theme with dark colors"
      :value="!!store.settings.darkMode"
      :handle-toggle-switch="(value) => (store.settings.darkMode = value)"
      class="mb-7"
    />
    <SettingsSwitch
      title="Bordered Theme"
      description="Apply borders to the theme"
      :value="!!store.settings.borderedTheme"
      :handle-toggle-switch="(value) => (store.settings.borderedTheme = value)"
      class="mb-7"
    />
  </Collapse>
</template>
