<script setup lang="ts">

import { defineProps } from 'vue';

defineProps<{
    message: string;
}>();

</script>

<template>
    <p>{{ message }}</p>
</template>


<style scoped>
p {
  color: red;
  font-weight: bold;
}
</style>