<template>
    <div class="redbox">
        <slot></slot>
    </div>
</template>

<style scoped>
    .redbox {
        border: 2px solid red;
        padding: 10px;
        display: inline-block;
    }
</style>