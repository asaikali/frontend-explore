<script setup lang="ts">
// import HelloWorld from './components/HelloWorld.vue'
import Simple from  './components/Text.vue'
import Greeting from './components/Greeting.vue'
import RedBox from './components/RedBox.vue'
import Counter from './components/counter.vue';
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
  
  <hr />
  <Counter />

  
  <!-- <HelloWorld msg="Vite + Vue" /> -->
</template>

<style scoped>
</style>
