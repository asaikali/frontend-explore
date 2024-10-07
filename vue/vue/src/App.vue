<script setup lang="ts">
// import HelloWorld from './components/HelloWorld.vue'
import Simple from  './components/Text.vue'
import Greeting from './components/Greeting.vue'
import RedBox from './components/RedBox.vue'
</script>

<template>

  <hr />
  <Simple />

  <hr />
  <Greeting message="Hello world" />
  
  <hr />
  <RedBox>
    <Simple />
    <Greeting message="Inside the redbox" />
  </RedBox>
  
  <!-- <HelloWorld msg="Vite + Vue" /> -->
</template>

<style scoped>
</style>
