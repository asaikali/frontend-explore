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

   oldMessages.value[count.value-1]= previous
    return "This a computed property based on count which has a value of " + count.value 

})
</script>

<template>
    <button @click="increment">
       Click to increment count={{ count }}
    </button>

    <!-- the :class directive evalutes to a comma seperated list of class names,
      based on evaluating the expressions -->
    <p :class="{ even: count % 2 === 0, odd: count % 2 === 1 }"
        class="count"> 
        {{ fullMessage }}
    </p>


    <ol v-if="oldMessages.length > 1"> 
        <li v-for="message in oldMessages">
            {{ message }}
        </li>
    </ol>
    <p v-else>The count is 0 there are no old computed messages</p>
</template>


<style scoped>

.count {
    font-weight: bold;
}

.odd {
    color: red;
}

.even {
    color: green;
}

</style>