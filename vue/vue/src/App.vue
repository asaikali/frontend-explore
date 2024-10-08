<script setup lang="ts">
// import HelloWorld from './components/HelloWorld.vue'
import Simple from  './components/Text.vue'
import Greeting from './components/Greeting.vue'
import RedBox from './components/RedBox.vue'
import Counter from './components/Counter.vue';
import Greeter from './components/Signup.vue';
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


  <hr />
  <Greeter />
  
  <!-- <HelloWorld msg="Vite + Vue" /> -->
</template>

<style>

.adib {
  text-align: center;
}
</style>
