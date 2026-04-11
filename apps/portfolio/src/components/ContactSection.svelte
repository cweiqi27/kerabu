<script lang="ts">
  let email = $state('');
  let message = $state('');
  let isSubmitted = $state(false);
  let isHovered = $state(false);

  function handleSubmit(e: Event) {
    e.preventDefault();
    isSubmitted = true;
  }
</script>

<a
  href="mailto:hello@example.com"
  class="inline-flex items-center gap-3 text-sm tracking-widest uppercase text-accent hover:text-accent/80 transition-colors duration-300"
  style="border-bottom: 1px solid var(--accent); padding-bottom: 4px;"
  onmouseenter={() => isHovered = true}
  onmouseleave={() => isHovered = false}
>
  <span>Say Hello</span>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="14"
    height="14"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    stroke-width="2"
    stroke-linecap="round"
    stroke-linejoin="round"
    class="transition-transform duration-300"
    style="transform: rotate({isHovered ? -45 : 0}deg)"
  >
    <line x1="7" y1="17" x2="17" y2="7"></line>
    <polyline points="7 7 17 7 17 17"></polyline>
  </svg>
</a>