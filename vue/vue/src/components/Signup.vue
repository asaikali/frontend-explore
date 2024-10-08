<script setup lang="ts">
import { ref } from 'vue'

const name = ref('')
const marketingEmails = ref(true)

</script>

<template>
    <p> Hello {{ name }}</p>
    <input type="text" v-model="name" placeholder="what's your name" />
    <input type="checkbox" id="makertingEmails" v-model="marketingEmails" />
    <label for="marketingEmails">{{ marketingEmails }}</label>
    
 </template>