<script setup lang="ts">

import { computed, ref } from 'vue'
const count = ref(0)

function increment() {
    count.value++
}

const oldMessages = ref<string[]>([]);

// computed propreties automaticaly change when the 
// underlying reactive values changes 
const fullMessage = computed( (previous: any) => {
    oldMessages.value.push(previous)
    return "This a computed property based on count which has a value of " + count.value 

})
</script>

<template>
    <button @click="increment">
       Click to increment count={{ count }}
    </button>

    <p> 
        {{ fullMessage }}
    </p>


    <p v-if="oldMessages.length > 1"> 
    {{ oldMessages }}
    </p>
</template>