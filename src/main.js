document.querySelector('#app').innerHTML = `
  <div style="font-family: system-ui, sans-serif; max-width: 560px; margin: 80px auto; text-align: center;">
    <h1>🎉 部署成功！</h1>
    <p>如果你能看到这个页面，说明这个前端应用已经通过 Docker 容器在运行了。</p>
    <p style="color: #888;">构建时间：${new Date().toLocaleString()}</p>
  </div>
`;
