<template>
    <div class="camera-container">
      <video ref="video" class="video" autoplay playsinline></video>
      <button @click="takePhoto" class="capture-button">Capture</button>
      <canvas ref="canvas" class="canvas"></canvas>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, onUnmounted } from 'vue';
  
  const video = ref(null);
  const canvas = ref(null);
  let stream = null;
  
  const startCamera = async () => {
    try {
      stream = await navigator.mediaDevices.getUserMedia({
        video: {
          facingMode: 'environment', // Use 'user' for front camera and 'environment' for back camera
        },
      });
      if (video.value) {
        video.value.srcObject = stream;
      }
    } catch (err) {
      console.error('Error accessing camera:', err);
    }
  };
  
  const takePhoto = () => {
    if (!video.value || !canvas.value) return;
  
    const context = canvas.value.getContext('2d');
    canvas.value.width = video.value.videoWidth;
    canvas.value.height = video.value.videoHeight;
    context.drawImage(video.value, 0, 0, canvas.value.width, canvas.value.height);
    // Additional functionality: Save image, process it, or upload it
  };
  
  onMounted(() => {
    startCamera();
  });
  
  onUnmounted(() => {
    if (stream) {
      stream.getTracks().forEach((track) => track.stop());
    }
  });
  </script>
  
  <style scoped>
  .camera-container {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  
  .video {
    width: 100%;
    max-width: 500px;
    height: auto;
    border: 1px solid #ccc;
    margin-bottom: 10px;
  }
  
  .capture-button {
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  
  .canvas {
    display: none;
  }
  </style>