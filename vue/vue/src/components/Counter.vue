<script setup lang="ts">

import { ref } from 'vue'
const count = ref(0)

function increment() {
    count.value++
}
</script>

<template>
    <button @click="increment">
       Click to increment count={{ count }}
    </button>
</template>