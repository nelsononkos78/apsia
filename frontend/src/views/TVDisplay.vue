<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import api from '../services/api';
import { websocketService } from '../services/websocket.service';
import GlobalHeader from '../components/common/GlobalHeader.vue';
import logo3 from '../assets/logo3.png';

interface CurrentCall {
  ticket: string;
  area: string;
  patient: string;
  updatedAt: string;
}

interface QueueItem {
  ticket: string;
  patient: string;
  status: string;
}

interface Area {
  name: string;
  items: QueueItem[];
}

interface WaitingRoomItem {
  id: number;
  patient: string;
  ticket: string;
  checkInTime: string;
  priority: string;
}

const currentCall = ref<CurrentCall | null>(null);
const activeAreas = ref<Area[]>([]);
const waitingRoom = ref<WaitingRoomItem[]>([]);
const loading = ref(true);
const isNewCall = ref(false);

const currentTime = ref('');
const currentDate = ref('');
let clockTimer: number | undefined;

const updateClock = () => {
  const now = new Date();
  currentTime.value = now.toLocaleTimeString('es-ES', { 
    hour: '2-digit', 
    minute: '2-digit' 
  });
  currentDate.value = now.toLocaleDateString('es-ES', { 
    weekday: 'long', 
    day: 'numeric', 
    month: 'long' 
  });
  
  // Recursive setTimeout for robust timing
  clockTimer = window.setTimeout(updateClock, 1000);
};

let player: any = null;

const initYouTubeAPI = () => {
  // Load the IFrame Player API code asynchronously.
  if (!(window as any).YT) {
    const tag = document.createElement('script');
    tag.src = "https://www.youtube.com/iframe_api";
    const firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode?.insertBefore(tag, firstScriptTag);
  }

  // This function creates an <iframe> (and YouTube player)
  // after the API code downloads.
  (window as any).onYouTubeIframeAPIReady = () => {
    player = new (window as any).YT.Player('youtube-player', {
      height: '100%',
      width: '100%',
      videoId: 'jRnqxURJ120',
      playerVars: {
        'autoplay': 1,
        'mute': 1, // Start muted to guarantee autoplay
        'loop': 1,
        'playlist': 'jRnqxURJ120',
        'controls': 0,
        'showinfo': 0,
        'rel': 0,
        'modestbranding': 1
      },
      events: {
        'onReady': (event: any) => {
          event.target.playVideo();
          // Attempt to unmute after a short delay
          setTimeout(() => {
            try {
              event.target.unMute();
              event.target.setVolume(50);
            } catch (e) {
              console.warn('Unmute failed:', e);
            }
          }, 3000);
        },
        'onStateChange': (event: any) => {
          if (event.data === (window as any).YT.PlayerState.ENDED) {
            player.playVideo(); 
          }
        }
      }
    });
  };

  // If API is already loaded, call the ready function manually
  if ((window as any).YT && (window as any).YT.Player) {
    (window as any).onYouTubeIframeAPIReady();
  }
};

const fetchState = async () => {
  try {
    const res = await api.get('/tv/state');
    currentCall.value = res.data.currentCall;
    activeAreas.value = res.data.activeAreas;
    waitingRoom.value = res.data.waitingRoom;
  } catch (error) {
    console.error('Error fetching TV state:', error);
  } finally {
    loading.value = false;
  }
};

const notificationAudio = new Audio('/sounds/doorbell.mp3');


const playNotificationSound = () => {
  try {
    console.log('🔔 Playing notification sound...');
    // Reset and play
    notificationAudio.currentTime = 0;
    notificationAudio.play().catch(e => {
      console.warn('Audio playback failed (likely autoplay policy):', e);
    });
    
    // Play second time after 2.5 seconds
    setTimeout(() => {
      notificationAudio.currentTime = 0;
      notificationAudio.play().catch(e => console.warn('Second audio playback failed:', e));
    }, 2500);
  } catch (error) {
    console.error('Error playing sound:', error);
  }
};

const handleTvUpdate = (state: any) => {
  console.log('📺 TV State updated via WebSocket:', state);
  
  currentCall.value = state.currentCall;
  activeAreas.value = state.activeAreas;
  waitingRoom.value = state.waitingRoom;
};

const handleTvCall = (data: any) => {
  console.log('🔔 TV Call event received:', data);
  playNotificationSound();
  isNewCall.value = true;
  setTimeout(() => {
    isNewCall.value = false;
  }, 5000); // Animation duration
};

onMounted(() => {
  updateClock(); // Start clock
  fetchState();
  websocketService.on('tv:state-updated', handleTvUpdate);
  websocketService.on('tv:call', handleTvCall);
  initYouTubeAPI();
  
  // Try to "prime" the audio context
  notificationAudio.volume = 0;
  notificationAudio.play().then(() => {
    console.log('✅ Audio context primed');
    notificationAudio.pause();
    notificationAudio.volume = 1;
  }).catch(() => {
    console.log('🔇 Audio context priming failed (expected without user interaction)');
    notificationAudio.volume = 1;
  });
});

onUnmounted(() => {
  if (clockTimer) clearTimeout(clockTimer);
  websocketService.off('tv:state-updated', handleTvUpdate);
  websocketService.off('tv:call', handleTvCall);
});
</script>

<template>
  <div class="h-screen w-screen bg-gray-900 text-white p-[2vmin] flex flex-col gap-[2vmin] overflow-hidden">
    
    <!-- Header / Top Bar (Solid & Elegant) -->
    <GlobalHeader :logo="logo3" hideTitle dark logoHeight="60px" fullWidth>
      <template #actions>
        <div class="flex items-center gap-[4vmin]">
          <button @click="playNotificationSound" class="opacity-0 hover:opacity-100 text-[1vmin] bg-gray-700 p-1 rounded">Test Sound</button>
          <div class="flex items-center gap-[1.5vmin] text-gray-400 text-[2.5vmin] font-medium">
            <i class="far fa-calendar-alt"></i>
            <span>{{ currentDate }}</span>
          </div>
          <div class="text-[4vmin] font-black text-white bg-gray-900 px-[3vmin] py-[0.5vmin] rounded-xl border-2 border-gray-700 shadow-inner">
            {{ currentTime }}
          </div>
        </div>
      </template>
    </GlobalHeader>

    <!-- Main Content Grid -->
    <div class="flex-1 flex flex-col gap-[2vmin] min-h-0">
      
      <!-- Top Row: Video & Current Call (Dominant Height) -->
      <div class="flex-[2.4] flex gap-[2vmin] min-h-0">
        <!-- Left: Video (Cinematic Size) -->
        <div class="w-[60%] bg-black rounded-2xl overflow-hidden border-2 border-gray-800 shadow-2xl relative">
           <div id="youtube-player" class="w-full h-full absolute inset-0"></div>
        </div>

        <!-- Right: High Impact Call (Turno Actual) -->
        <div 
          class="flex-1 bg-gray-800 rounded-2xl p-[4vmin] border-4 border-primary shadow-2xl flex flex-col items-center justify-center text-center relative overflow-hidden transition-all duration-500"
          :class="{ 'shimmer-effect border-white scale-[1.02]': isNewCall }"
        >
          <!-- Subtle solid accent -->
          <div class="absolute top-0 left-0 w-full h-[1vmin] bg-primary"></div>
          
          <h2 class="text-[4vmin] font-black text-gray-400 mb-[4vmin] uppercase tracking-[0.2em]">Turno Actual</h2>
          
          <div v-if="currentCall" class="animate-bounce-in w-full flex flex-col items-center justify-center h-full">
            <div class="text-[16vmin] leading-none font-black text-white mb-[2vmin] tracking-tighter">
              {{ currentCall.ticket }}
            </div>
            <div class="text-[5vmin] font-bold text-primary mb-[2vmin] bg-primary/10 py-[1vmin] px-[3vmin] rounded-xl inline-block">
              {{ currentCall.area }}
            </div>
            <div class="text-[3.5vmin] font-medium text-gray-300">
              {{ currentCall.patient }}
            </div>
          </div>
          
          <div v-else class="text-gray-600 text-[3vmin] font-medium flex flex-col items-center">
            <i class="fas fa-clock mb-[2vmin] text-[6vmin] block opacity-20"></i>
            Esperando próximos llamados...
          </div>
        </div>
      </div>

      <!-- Bottom Row: Waiting Room (Full Width, Solid Cards) -->
      <div class="flex-[1] bg-gray-800 rounded-2xl p-[2vmin] border-2 border-gray-700 flex flex-col overflow-hidden shadow-xl min-h-0">
        <div class="flex-none flex justify-between items-center mb-[1.5vmin] border-b border-gray-700 pb-[1vmin]">
          <div class="flex items-center gap-[1.5vmin]">
            <i class="fas fa-users text-primary text-[2.5vmin]"></i>
            <h3 class="text-[2.5vmin] font-bold text-white uppercase tracking-wider">Sala de Espera</h3>
          </div>
          <span class="bg-gray-900 text-primary border border-primary/30 px-[2vmin] py-[0.5vmin] rounded-full text-[2vmin] font-black">
            {{ waitingRoom.length }} PACIENTES
          </span>
        </div>
        
        <div v-if="waitingRoom.length === 0" class="flex-1 flex items-center justify-center text-gray-600 text-[2.5vmin] italic">
          No hay pacientes en espera
        </div>
        
        <div v-else class="flex-1 overflow-y-auto custom-scrollbar pr-[1vmin]">
          <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-5 gap-[1.5vmin]">
            <div 
              v-for="item in waitingRoom" 
              :key="item.id"
              class="bg-gray-900 px-[2vmin] py-[1vmin] rounded-xl border-2 border-gray-700 flex items-center gap-[1.5vmin] relative overflow-hidden transition-transform hover:scale-[1.02] min-w-0"
              :class="item.priority === 'URGENTE' ? 'border-red-600 bg-red-950/20' : ''"
            >
              <div v-if="item.priority === 'URGENTE'" class="absolute top-0 right-0 bg-red-600 text-white text-[1vmin] px-[0.8vmin] py-[0.1vmin] font-black uppercase tracking-widest">Urgente</div>
              <span class="text-[3vmin] font-black text-primary flex-none">{{ item.ticket }}</span>
              <span class="text-[2.5vmin] font-bold text-white truncate flex-1">{{ item.patient }}</span>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>



<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 8px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: rgba(0,0,0,0.2);
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(255,255,255,0.1);
  border-radius: 4px;
}
.animate-bounce-in {
  animation: bounceIn 0.8s cubic-bezier(0.215, 0.61, 0.355, 1);
}

@keyframes bounceIn {
  0% { opacity: 0; transform: scale(0.3); }
  20% { transform: scale(1.1); }
  40% { transform: scale(0.9); }
  60% { opacity: 1; transform: scale(1.03); }
  80% { transform: scale(0.97); }
  100% { opacity: 1; transform: scale(1); }
}

.shimmer-effect {
  position: relative;
  overflow: hidden;
  background: linear-gradient(
    110deg,
    #1f2937 8%,
    #374151 18%,
    #1f2937 33%
  );
  background-size: 200% 100%;
  animation: 1.5s shimmer linear infinite;
}

@keyframes shimmer {
  to {
    background-position-x: -200%;
  }
}
</style>
