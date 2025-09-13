<template>
    <div class="chat-input">
      <input
        v-model="message"
        @keydown.enter="sendMessage"
        type="text"
        placeholder="Type your message..."
        class="chat-input-box"
      />
      <button @click="sendMessage" class="chat-send-button">Send</button>
    </div>
  </template>
  
  <script>
  export default {
    name: "ChatInput",
    data() {
      return {
        message: "",
      };
    },
    methods: {
      sendMessage() {
        if (this.message.trim()) {
          // Emit the message to the parent component
          this.$emit("send-message", this.message.trim());
          // Clear the input box
          this.message = "";
        }
      },
    },
  };
  </script>
  
  <style scoped>
  .chat-input {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px;
    background-color: #f0f0f0;
    border-top: 1px solid #ccc;
  }
  
  .chat-input-box {
    flex: 1;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 16px;
  }
  
  .chat-send-button {
    padding: 10px 15px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
  }
  
  .chat-send-button:hover {
    background-color: #0056b3;
  }
  </style>