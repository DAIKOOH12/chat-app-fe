<template>
  <div
    class="w-full min-h-[5rem] max-h-fit px-5 py-6 flex justify-between items-center"
  >
    <p
      tabindex="0"
      class="heading-1 text-black/70 dark:text-white/70 outline-none"
    >
      <slot name="title"></slot>
    </p>

    <div>
      <slot name="actions"></slot>
    </div>
  </div>
</template>
