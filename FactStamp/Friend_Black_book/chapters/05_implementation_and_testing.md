CHAPTER 5: IMPLEMENTATION AND TESTING
5.1 Implementation Approaches
Project Summary
RoomieSync is a smart flatmate and accommodation management system designed to help users find
suitable roommates, search and book properties, communicate with matched users, subscribe to meal plans,
generate agreements, and manage shared expenses. The system is implemented using a modular approach,
where each major functionality is developed as a separate module. MongoDB is used for storing user,
property, roommate matching, chat, meal, agreement, expense, and review data. The implementation focuses
on providing a simple, secure, efficient, and user-friendly application.

5.2 Coding Details and Code Efficiency
The RoomieSync application is developed using a modular coding approach. The code is divided into
separate components for authentication, user profile management, roommate matching, property
management, chat, meal subscription, agreement generation, expense management, and reviews. Reusable
functions and components are used wherever possible to reduce code duplication. Proper validation and
error handling are implemented to improve the reliability of the system. Database queries are designed to
retrieve only the required information, thereby reducing unnecessary processing and improving application
performance.
5.2.1 Coding details:
Module 1 – Roommate Compatibility Matching
Frontend
import React, { useState, useEffect, useRef } from 'react';
import {
Sparkles, Filter, CheckCircle, XCircle, Send, Eye, ShieldCheck,
Heart, UserCheck, Flame, Search, MapPin, DollarSign, Utensils, Moon, Briefcase, Smile, CheckCircle2, Clock, Star, X, Check
} from 'lucide-react';
import { apiService } from '../services/api';
import { calculateCompatibility } from '../services/matchingEngine';
const DATA_AVATAR_FALLBACK = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='100' height='100'
viewBox='0 0 24 24' fill='%231f2937' stroke='%239ca3af' stroke-width='1.5'><rect width='100%' height='100%' fill='%23374151'/><circle
cx='12' cy='8' r='4'/><path d='M6 21v-2a4 4 0 0 1 4-4h4a4 4 0 0 1 4 4v2'/></svg>";
export default function MatchingPage({ currentUser }) {
const [userProfile, setUserProfile] = useState({});
const [candidates, setCandidates] = useState([]);
const [searchQuery, setSearchQuery] = useState('');
const [budgetFilter, setBudgetFilter] = useState('All');
const [foodFilter, setFoodFilter] = useState('All');
const [selectedCandidate, setSelectedCandidate] = useState(null);
const [requestedIds, setRequestedIds] = useState([]);
const [matchRequests, setMatchRequests] = useState([]);
const [loading, setLoading] = useState(true);
const isMounted = useRef(true);
useEffect(() => {
isMounted.current = true;
const fetchData = async () => {
const userId = currentUser?.id || currentUser?._id;
if (!userId) {
if (isMounted.current) setLoading(false);
return;
}
try {
if (isMounted.current) setLoading(true);
const safeGetProfile = (id) => apiService.getProfile(id).catch(() => ({}));
const safeGetUsers = () => apiService.getUsers().catch(() => []);
const [myProfile, users] = await Promise.all([
safeGetProfile(userId),
safeGetUsers()
]);
if (!isMounted.current) return;
setUserProfile(myProfile || {});
const otherUsers = (users || []).filter(u => u && (u.id || u._id) !== userId && u.role === 'user');
const candidatePromises = (otherUsers || []).map(async (u) => {
const uId = u?.id || u?._id;
const prof = uId ? await safeGetProfile(uId) : {};
const score = calculateCompatibility(myProfile || {}, prof || {});
return { user: u || {}, profile: prof || {}, score: score || 50 };
});
const candidateList = await Promise.all(candidatePromises);
if (!isMounted.current) return;
candidateList.sort((a, b) => (b.score || 0) - (a.score || 0));
setCandidates(candidateList);
setMatchRequests([]);
} catch (err) {

console.error('Failed to fetch matching data:', err);
} finally {
if (isMounted.current) {
setLoading(false);
}
}
};
fetchData();
return () => {
isMounted.current = false;
};
}, [currentUser?.id, currentUser?._id]);
const handleImageError = (e) => {
e.target.onerror = null;
e.target.src = DATA_AVATAR_FALLBACK;
};
const filteredCandidates = (candidates || []).filter(item => {
if (!item) return false;
if (searchQuery && searchQuery.trim()) {
const q = searchQuery.toLowerCase();
const nameMatch = (item.user?.name || '').toLowerCase().includes(q);
const locMatch = (item.profile?.preferredLocation || '').toLowerCase().includes(q);
const occMatch = (item.profile?.occupation || '').toLowerCase().includes(q);
if (!nameMatch && !locMatch && !occMatch) return false;
}
if (foodFilter !== 'All' && item.profile?.foodPref !== foodFilter) return false;
if (budgetFilter !== 'All') {
const maxB = Array.isArray(item.profile?.budget) && item.profile.budget.length === 2
? Number(item.profile.budget[1])
: 25000;
if (budgetFilter === 'Under15k' && maxB > 15000) return false;
if (budgetFilter === '15k-25k' && (maxB < 15000 || maxB > 25000)) return false;
}
return true;
});
const handleSendMatch = (candidateId) => {
if (!candidateId) return;
setRequestedIds(prev => (prev || []).includes(candidateId) ? prev : [...(prev || []), candidateId]);
};
const handleRespond = (reqId, status) => {
if (!reqId) return;
setMatchRequests(prev => (prev || []).map(r => r?.id === reqId ? { ...r, status } : r));
};
if (loading) {
return (
<div className="max-w-7xl mx-auto py-12 px-4 flex flex-col items-center justify-center min-h-[400px]">
<Sparkles className="w-8 h-8 text-[var(--accent-gold)] animate-spin mb-3" />
<p className="text-sm theme-text-sub font-medium">Finding potential roommate matches...</p>
</div>
);
}
return (
<div className="max-w-7xl mx-auto py-6 px-4 space-y-8">
{/* Page Header */}
<div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-4">
<div>
<div className="flex items-center gap-2 mb-1">
<span className="text-xs font-semibold theme-text-accent uppercase tracking-widest">Matching Engine</span>
<span className="theme-badge-amber text-[10px] font-bold px-2 py-0.5 rounded-full flex items-center gap-1 font-mono-numbers">
<Flame className="w-3 h-3 text-[var(--accent-gold)]" /> AI Weighted 6-Factor
</span>
</div>
<h1 className="text-3xl font-extrabold theme-text-main font-display tracking-tight">
Find Your Ideal Roommate
</h1>
<p className="theme-text-sub text-xs mt-1">
Algorithmically scored based on budget overlap, food diet, sleep rhythm, and cleanliness habits.
</p>
</div>
{/* Search & Filter Controls Bar */}
<div className="flex flex-col sm:flex-row items-center gap-3 w-full lg:w-auto">
{/* Search Box */}

<div className="relative w-full sm:w-64">
<Search className="w-4 h-4 theme-text-muted absolute left-3.5 top-3" />
<input
type="text"
placeholder="Search by name, role or city..."
value={searchQuery}
onChange={(e) => setSearchQuery(e.target.value)}
className="w-full theme-input py-2 pl-10 pr-4 text-xs outline-none"
/>
</div>
{/* Filters Dropdown */}
<div className="flex items-center gap-2 w-full sm:w-auto">
<select
value={foodFilter}
onChange={(e) => setFoodFilter(e.target.value)}
className="theme-input px-3 py-2 text-xs outline-none font-medium flex-1 sm:flex-initial"
>
<option value="All">All Diets</option>
<option value="Veg">Vegetarian</option>
<option value="Non-Veg">Non-Veg</option>
<option value="Vegan">Vegan</option>
</select>
<select
value={budgetFilter}
onChange={(e) => setBudgetFilter(e.target.value)}
className="theme-input px-3 py-2 text-xs outline-none font-medium flex-1 sm:flex-initial font-mono-numbers"
>
<option value="All">All Budgets</option>
<option value="Under15k">Under ₹15,000</option>
<option value="15k-25k">₹15k - ₹25k</option>
</select>
</div>
</div>
</div>
{/* Incoming Match Requests Banner */}
{(matchRequests || []).length > 0 && (
<div className="bento-card p-6 border-[var(--surface-border-accent)]">
<div className="flex items-center justify-between mb-4">
<h2 className="text-sm font-bold theme-text-accent uppercase tracking-wider flex items-center gap-2 font-display">
<Sparkles className="w-4 h-4 text-[var(--accent-gold)]" /> Pending Roommate Match Requests Received
</h2>
<span className="text-xs theme-badge-emerald px-2.5 py-0.5 rounded-full font-mono-numbers">
{(matchRequests || []).filter(r => r?.status === 'pending').length} Action Required
</span>
</div>
<div className="grid grid-cols-1 md:grid-cols-2 gap-4">
{(matchRequests || []).map(req => (
<div key={req?.id || req?.fromUser?.name} className="p-4 rounded-2xl bento-card-static flex items-center justify-between gap-4">
<div className="flex items-center gap-3">
<img
src={req?.fromUser?.avatar || DATA_AVATAR_FALLBACK}
alt=""
onError={handleImageError}
className="w-12 h-12 rounded-xl object-cover ring-2 ring-[var(--brand-accent)]/40"
/>
<div>
<h4 className="text-sm font-bold theme-text-main font-display">{req?.fromUser?.name || 'User'}</h4>
<p className="text-xs text-[var(--accent-emerald)] font-bold font-mono-numbers">{req?.score || 50}% High Match Score</p>
</div>
</div>
{req?.status === 'pending' ? (
<div className="flex items-center gap-2">
<button
onClick={() => handleRespond(req.id, 'accepted')}
className="px-3.5 py-2 rounded-xl gradient-btn text-xs font-bold flex items-center gap-1 transition-all duration-200 hover:-
translate-y-0.5 active:scale-95"
>
<CheckCircle className="w-3.5 h-3.5" /> Accept
</button>
<button
onClick={() => handleRespond(req.id, 'rejected')}

className="px-3 py-2 rounded-xl theme-btn-secondary text-xs font-semibold transition-all duration-200 hover:-translate-y-0.5
active:scale-95"
>
Decline
</button>
</div>
) : (
<span className={`text-xs font-bold px-3 py-1 rounded-full flex items-center gap-1.5 ${req?.status === 'accepted' ? 'theme-badge-
emerald' : 'theme-badge-amber'}`}>
{req?.status === 'accepted' ? (
<>
<Sparkles className="w-3.5 h-3.5" />
<span>Match Accepted</span>
</>
) : (
<span>Request Declined</span>
)}
</span>
)}
</div>
))}
</div>
</div>
)}
{/* Recommended Candidates Grid */}
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
{(filteredCandidates || []).length === 0 ? (
<div className="col-span-full bento-card p-12 text-center text-xs theme-text-muted">
No candidate roommate profiles match your selected filters. Try broadening your criteria.
</div>
) : (
(filteredCandidates || []).map(({ user, profile, score }) => {
const userId = user?.id || user?._id;
const isRequested = (requestedIds || []).includes(userId);
const hobbies = (profile && Array.isArray(profile.hobbies)) ? profile.hobbies : [];
const candidateScore = typeof score === 'number' ? score : 50;
return (
<div key={userId || user?.name} className="bento-card p-6 flex flex-col justify-between relative overflow-hidden group">
{/* Score Tag Pill */}
<div className="absolute top-4 right-4 px-3 py-1 rounded-full theme-badge-amber flex items-center gap-1.5 shadow-md">
<Sparkles className="w-3.5 h-3.5 text-[var(--accent-gold)]" />
<span className="text-xs font-extrabold font-mono-numbers">
{candidateScore}% Match
</span>
</div>
<div>
{/* Candidate Header */}
<div className="flex items-center gap-4 mb-4">
<img
src={user?.avatar || DATA_AVATAR_FALLBACK}
alt={user?.name || ''}
onError={handleImageError}
className="w-14 h-14 rounded-2xl object-cover ring-2 ring-[var(--brand-accent)]/30 shrink-0"
/>
<div>
<h3 className="text-base font-bold theme-text-main group-hover:theme-text-accent transition-colors font-display">{user?.name
|| 'User'}</h3>
<p className="text-xs theme-text-sub flex items-center gap-1">
<Briefcase className="w-3 h-3 theme-text-muted" />
<span>{profile?.occupation || 'Not specified'}</span>
</p>
<p className="text-[11px] theme-text-accent font-semibold flex items-center gap-1 mt-0.5">
<MapPin className="w-3 h-3 shrink-0" />
<span>{profile?.preferredLocation || 'Not specified'}</span>
</p>
</div>
</div>
{/* Bio quote */}
<p className="text-xs theme-text-sub line-clamp-2 mb-4 italic bento-card-static p-2.5 rounded-xl">
"{profile?.bio || 'No bio provided.'}"
</p>
{/* Lifestyle Attribute Metrics */}

<div className="space-y-2 text-xs mb-5">
{/* Budget Bar */}
<div className="bento-card-static p-2.5 rounded-xl flex items-center justify-between">
<span className="theme-text-muted flex items-center gap-1 text-[11px]">
<DollarSign className="w-3.5 h-3.5 text-[var(--accent-emerald)]" /> Max Rent:
</span>
<span className="font-bold text-[var(--accent-emerald)] font-mono-numbers text-xs">
₹{(profile?.budget?.[1] || 0).toLocaleString()} / mo
</span>
</div>
{/* Food & Sleep Split */}
<div className="grid grid-cols-2 gap-2 text-[11px]">
<div className="bento-card-static p-2.5 rounded-xl">
<span className="theme-text-muted block text-[10px]">Diet:</span>
<span className="font-bold theme-text-main flex items-center gap-1 mt-0.5">
<Utensils className="w-3 h-3 theme-text-accent" /> {profile?.foodPref || 'Not specified'}
</span>
</div>
<div className="bento-card-static p-2.5 rounded-xl">
<span className="theme-text-muted block text-[10px]">Sleep:</span>
<span className="font-bold theme-text-main flex items-center gap-1 mt-0.5">
<Moon className="w-3 h-3 text-[var(--accent-gold)]" /> {profile?.sleepSchedule || 'Flexible'}
</span>
</div>
</div>
{/* Hobbies Badges */}
<div className="flex flex-wrap gap-1.5 pt-1">
{(hobbies || []).map((h, i) => (
<span key={i} className="text-[10px] theme-btn-secondary px-2 py-0.5 rounded-md font-medium">
#{h}
</span>
))}
</div>
</div>
</div>
{/* Actions */}
<div className="flex items-center gap-2 pt-2 border-t border-[var(--surface-border)]">
<button
onClick={() => setSelectedCandidate({ user, profile: profile || {}, score: candidateScore })}
className="flex-1 py-2.5 rounded-xl theme-btn-secondary text-xs font-semibold flex items-center justify-center gap-1.5 transition-
all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Eye className="w-3.5 h-3.5 text-[var(--brand-accent)]" />
<span>Breakdown</span>
</button>
<button
onClick={() => handleSendMatch(userId)}
disabled={isRequested}
className={`flex-1 py-2.5 rounded-xl text-xs font-semibold flex items-center justify-center gap-1.5 transition-all duration-200
hover:-translate-y-0.5 active:scale-95 ${
isRequested
? 'theme-btn-secondary opacity-70 cursor-not-allowed text-[var(--accent-emerald)]'
: 'gradient-btn'
}`}
>
{isRequested ? (
<>
<UserCheck className="w-3.5 h-3.5 text-[var(--accent-emerald)]" />
<span>Requested</span>
</>
) : (
<>
<Send className="w-3.5 h-3.5" />
<span>Send Request</span>
</>
)}
</button>
</div>
</div>
);
})
)}

</div>
{/* Deep Analytics Compatibility Breakdown Modal */}
{selectedCandidate && (
<div className="fixed inset-0 z-50 bg-black/80 ba ckdrop-blur-sm flex items-center justify-center p-4">
<div className="max-w-md w-full glass-panel p-6 sm:p-8 rounded-3xl border border-[var(--surface-border-accent)] shadow-2xl relative
animate-in fade-in zoom-in-95 duration-200 max-h-[90vh] overflow-y-auto">
<button
onClick={() => setSelectedCandidate(null)}
className="absolute top-4 right-4 theme-text-muted hover:theme-text-main p-1 transition-all duration-200 hover:-translate-y-0.5
active:scale-95"
aria-label="Close"
>
<X className="w-5 h-5" />
</button>
<div className="flex items-center gap-4 mb-6">
<img
src={selectedCandidate.user?.avatar || DATA_AVATAR_FALLBACK}
onError={handleImageError}
className="w-16 h-16 rounded-2xl object-cover ring-2 ring-[var(--brand-accent)]"
alt=""
/>
<div>
<h3 className="text-xl font-bold theme-text-main font-display">{selectedCandidate.user?.name || 'Candidate'}</h3>
<p className="text-xs theme-text-accent font-medium">{selectedCandidate.profile?.occupation || 'Not specified'}</p>
<p className="text-[11px] theme-text-muted">{selectedCandidate.profile?.preferredLocation || 'Not specified'}</p>
</div>
</div>
{/* Score Ring Banner */}
<div className="mb-6 p-4 rounded-2xl bento-card-static text-center border border-[var(--surface-border-accent)]">
<span className="text-3xl font-extrabold theme-text-accent font-mono-numbers block">
{selectedCandidate.score || 50}% Overall Compatibility
</span>
<p className="text-[11px] theme-text-muted mt-1">Weighted against your profile preferences</p>
</div>
{/* Dimensional Breakdown */}
<div className="space-y-3 text-xs mb-6">
<div className="bento-card-static p-3 rounded-xl space-y-1">
<div className="flex justify-between items-center font-semibold">
<span className="theme-text-sub">Budget Overlap (25% Weight)</span>
<span className="text-[var(--accent-emerald)] font-mono-numbers">High Alignment</span>
</div>
<div className="w-full h-1.5 bento-card-static rounded-full overflow-hidden">
<div className="h-full bg-[var(--accent-emerald)] w-[95%]"></div>
</div>
</div>
<div className="bento-card-static p-3 rounded-xl space-y-1">
<div className="flex justify-between items-center font-semibold">
<span className="theme-text-sub">Dietary Match (20% Weight)</span>
<span className="theme-text-accent">
{userProfile?.foodPref && selectedCandidate.profile?.foodPref && userProfile.foodPref === selectedCandidate.profile.foodPref
? 'Exact Match (100%)'
: 'Compatible (75%)'}
</span>
</div>
<div className="w-full h-1.5 bento-card-static rounded-full overflow-hidden">
<div className="h-full bg-[var(--brand-accent)] w-[85%]"></div>
</div>
</div>
<div className="bento-card-static p-3 rounded-xl space-y-1">
<div className="flex justify-between items-center font-semibold">
<span className="theme-text-sub">Sleep Rhythm (20% Weight)</span>
<span className="text-[var(--accent-gold)] font-mono-numbers">{selectedCandidate.profile?.sleepSchedule || 'Flexible'}</span>
</div>
<div className="w-full h-1.5 bento-card-static rounded-full overflow-hidden">
<div className="h-full bg-[var(--accent-gold)] w-[90%]"></div>
</div>
</div>
<div className="bento-card-static p-3 rounded-xl space-y-1">
<div className="flex justify-between items-center font-semibold">
<span className="theme-text-sub">Cleanliness Rating (15% Weight)</span>
<div className="flex items-center gap-0.5">
{Array.from({ length: 5 }).map((_, i) => (

<Star
key={i}
className={`w-3 h-3 ${
i < Math.max(1, Math.min(5, Number(s electedCandidate.profile?.cleanliness) || 4))
? 'text-amber-400 fill-amber-400'
: 'text-slate-500/30'
}`}
/>
))}
</div>
</div>
<div className="w-full h-1.5 bento-card-static rounded-full overflow-hidden">
<div className="h-full bg-[var(--accent-gold)] w-[80%]"></div>
</div>
</div>
</div>
<button
onClick={() => {
handleSendMatch(selectedCandidate.user?.id || selectedCandidate.user?._id);
setSelectedCandidate(null);
}}
className="w-full py-3 gradient-btn text-xs font-bold uppercase tracking-wider flex items-center justify-center gap-2 transition-all
duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Send className="w-4 h-4" />
<span>Send Roommate Request Now</span>
</button>
</div>
</div>
)}
</div>
);
}

Module 2 –
Frontend
import React, { useState, useEffect } fro m 'react';
import {
User, Briefcase, MapPin, DollarSign, Utensils, Moon, Sparkles, Heart, CheckCircle2, Save, Cigarette,
Star, ShieldCheck
} from 'lucide-react';
import { apiService } from '../services/api';
import { sanitizeInput } from '../utils/sanitizer';
export default function ProfilePage({ user, onProfileUpdated }) {
const [occupation, setOccupation] = useState('');
const [minBudget, setMinBudget] = useState('');
const [maxBudget, setMaxBudget] = useState('');
const [foodPref, setFoodPref] = useState('Veg');
const [sleepSchedule, setSleepSchedule] = useState('Flexible');
const [cleanliness, setCleanliness] = useState(3);
const [smokingDrinking, setSmokingDrinking] = useState('Non-Smoker / Non-Drinker');
const [preferredLocation, setPreferredLocation] = useState('');
const [bio, setBio] = useState('');
const [hobbiesInput, setHobbiesInput] = useState('');
const [savedSuccess, setSavedSuccess] = useState(false);
const [isSaving, setIsSaving] = useState(false);
useEffect(() => {
const userId = user?.id || user?._id;
if (!userId) return;
let isMounted = true;
const loadProfile = async () => {
try {
const profile = await apiService.getProfile(userId);
if (isMounted && profile) {
if (profile.occupation) setOccupation(profile.occupation);
if (profile.budget && Array.isArray(profile.budget)) {
setMinBudget(profile.budget[0] ?? '');
setMaxBudget(profile.budget[1] ?? '');
}
if (profile.foodPref) setFoodPref(profile.foodPref);
if (profile.sleepSchedule) setSleepSchedule(profile.sleepSchedule);
if (profile.cleanliness !== undefined && profile.cleanliness !== null) {
setCleanliness(profile.cleanliness);
}
if (profile.smokingDrinking) setSmokingDrinking(profile.smokingDrinking);
if (profile.preferredLocation) setPreferredLocation(profile.preferredLocation);
if (profile.bio) setBio(profile.bio);
if (profile.hobbies) {
setHobbiesInput(Array.isArray(profile.hobbies) ? profile.hobbies.join(', ') : profile.hobbies);
}
}
} catch (err) {
console.error("Failed to fetch profile:", err);
}
};
loadProfile();
return () => { isMounted = false; };
}, [user?.id, user?._id]);

const handleSave = async (e) => {
e.preventDefault();
const userId = user?.id || user?._id;
if (!userId) {
console.warn("No user ID available for profile update");
return;
}
const rawHobbies = typeof hobbiesInput === 'string'
? hobbiesInput.split(',').map(s => s.trim()).filter(Boolean)
: (Array.isArray(hobbiesInput) ? hobbiesInput : []);
const hobbiesArray = rawHobbies.map(h => sanitizeInput(h)).filter(Boolean);
const profilePayload = {
occupation: sanitizeInput(occupation) || '',
budget: [Number(minBudget) || 0, Number(maxBudget) || 0],
foodPref: sanitizeInput(foodPref) || 'Veg',
sleepSchedule: sanitizeInput(sleepSchedule) || 'Flexible',
cleanliness: Number(cleanliness) || 3,
smokingDrinking: sanitizeInput(smokingDrinking) || 'Non-Smoker / Non-Drinker',
preferredLocation: sanitizeInput(preferredLocation) || '',
bio: sanitizeInput(bio, { allowMultiline: true }),
hobbies: hobbiesArray
};
setIsSaving(true);
setSavedSuccess(false);
try {
const res = await apiService.updateProfile(userId, profilePayload);
const updatedProfile = res?.profile || res || profilePayload;
setSavedSuccess(true);
const fullUpdatedUser = {
...user,
...updatedProfile,
id: userId,
_id: userId
};
if (onProfileUpdated) {
onProfileUpdated(fullUpdatedUser);
}
setTimeout(() => setSavedSuccess(false), 3000);
} catch (err) {
console.error("Error updating profile:", err);
} finally {
setIsSaving(false);
}
};
const cleanStarCount = Math.max(1, Math.min(5, Math.round(Number(cleanliness)) || 1));
return (
<div className="max-w-5xl mx-auto py-8 px-4 space-y-8">
{/* Header Banner */}
<div className="bento-card p-6 sm:p-8 flex flex-col sm:flex-row items-start sm:items-center
justify-between gap-6">
<div>
<span className="text-xs font-bold uppercase tracking-widest theme-text-accent">
Lifestyle Profile Setup
</span>

<h1 className="text-3xl font-extrabold theme-text-main font-display flex items-center gap-2">
<span>Profile & Preferences</span>
<Sparkles className="w-6 h-6 t ext-[var(--accent-gold)]" />
</h1>
<p className="theme-text-sub text-xs mt-1 max-w-xl">
Your preferences feed into the Weighted AI Compatibility Engine to connect you with like-
minded roommates.
</p>
</div>
{savedSuccess && (
<div className="flex items-center gap-2 px-4 py-2.5 rounded-xl theme-badge-emerald text-xs
font-bold shrink-0 animate-bounce">
<CheckCircle2 className="w-4 h-4 text-[var(--accent-emerald)]" />
<span>Profile Saved!</span>
</div>
)}
</div>
<form onSubmit={handleSave} className="grid grid-cols-1 lg:grid-cols-12 gap-8">
{/* Left Column: Avatar & Summary Card (4 Cols on Large) */}
<div className="lg:col-span-4 space-y-6">
<div className="bento-card p-6 flex flex-col items-center text-center space-y-4 transition-all
duration-200 hover:-translate-y-0.5">
<div className="relative">
{user?.avatar ? (
<img
src={user.avatar}
alt={user?.name || 'User'}
className="w-28 h-28 rounded-3xl object-cover ring-4 ring-[var(--brand-accent)]/30
shadow-xl"
/>
) : (
<div className="w-28 h-28 rounded-3xl bg-[var(--brand-primary)]/20 text-[var(--brand-
accent)] font-bold flex items-center justify-center text-3xl shadow-xl">
{user?.name ? user.name.charAt(0).toUpperCase() : 'U'}
</div>
)}
<span className="w-4 h-4 rounded-full bg-[var(--accent-emerald)] absolute bottom-1 right-1
ring-2 ring-[var(--surface-card)]" title="Active Seeker"></span>
</div>
<div>
<h2 className="text-xl font-bold theme-text-main font-display">{user?.name || 'User'}</h2>
<span className="text-xs theme-text-accent font-medium block mt-0.5">{user?.email ||
''}</span>
<span className="inline-block mt-2 text-[10px] uppercase font-bold theme-badge-primary
px-2.5 py-0.5 rounded-full">
{user?.role || 'user'} Account
</span>
</div>
<div className="w-full bento-card-static p-4 text-left text-xs space-y-3">
<div className="flex items-center gap-2.5 theme-text-sub">
<Briefcase className="w-4 h-4 text-[var(--brand-accent)] shrink-0" />
<span className="truncate">{occupation || 'Occupation Not Specified'}</span>
</div>
<div className="flex items-center gap-2.5 theme-text-sub">

<MapPin className="w-4 h-4 text-[var(--accent-gold)] shrink-0" />
<span className="truncate">{preferredLocation || 'Location Not Specified'}</span>
</div>
<div className="flex items-center gap-2.5 theme-text-sub">
<DollarSign className="w-4 h-4 text-[var(--accent-emerald)] shrink-0" />
<span className="font-mono-numbers font-bold text-xs">
₹{Number(minBudget || 0).toLocaleString()} - ₹{Number(maxBudget || 0).toLocaleString()}
/ mo
</span>
</div>
</div>
<button
type="submit"
disabled={isSaving}
className="w-full py-3.5 gradient-btn flex items-center justify-center gap-2 text-xs
uppercase font-bold tracking-wider shadow-lg transition-all duration-200 hover:-translate-y-0.5
active:scale-95 disabled:opacity-50"
>
<Save className="w-4 h-4" />
<span>{isSaving ? 'Saving...' : 'Save Changes'}</span>
</button>
</div>
</div>
{/* Right Column: Detailed Preferences Matrix (8 Cols on Large) */}
<div className="lg:col-span-8 space-y-6">
{/* Bento Card 1: Personal & Location Details */}
<div className="bento-card p-6 space-y-4 transition-all duration-200 hover:-translate-y-0.5">
<h3 className="text-sm font-bold theme-text-main uppercase tracking-wider flex items-
center gap-2 font-display">
<User className="w-4 h-4 text-[var(--brand-accent)]" />
<span>Personal Information</span>
</h3>
<div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Occupation</label>
<input
type="text"
value={occupation}
onChange={(e) => setOccupation(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
placeholder="e.g. Software Engineer"
/>
</div>
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Preferred
Location</label>
<input
type="text"
value={preferredLocation}
onChange={(e) => setPreferredLocation(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
placeholder="e.g. HSR Layout, Bangalore"

/>
</div>
</div>
</div>
{/* Bento Card 2: Budget Range */}
<div className="bento-card p-6 space-y-4 transition-all duration-200 hover:-translate-y-0.5">
<div className="flex items-center justify-between">
<h3 className="text-sm font-bold theme-text-main uppercase tracking-wider flex items-
center gap-2 font-display">
<DollarSign className="w-4 h-4 text-[var(--accent-emerald)]" />
<span>Monthly Rent Budget Range</span>
</h3>
<span className="text-xs font-bold text-[var(--accent-emerald)] font-mono-numbers">
₹{Number(minBudget || 0).toLocaleString()} - ₹{Number(maxBudget || 0).toLocaleString()}
</span>
</div>
<div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Min Budget (₹ /
mo)</label>
<input
type="number"
step="1000"
value={minBudget}
onChange={(e) => setMinBudget(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none font-mono-numbers focus:border-
[var(--brand-accent)] transition-all duration-200"
placeholder="10000"
/>
</div>
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Max Budget (₹ /
mo)</label>
<input
type="number"
step="1000"
value={maxBudget}
onChange={(e) => setMaxBudget(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none font-mono-numbers focus:border-
[var(--brand-accent)] transition-all duration-200"
placeholder="25000"
/>
</div>
</div>
</div>
{/* Bento Card 3: Lifestyle Habits Grid */}
<div className="bento-card p-6 space-y-4 transition-all duration-200 hover:-translate-y-0.5">
<h3 className="text-sm font-bold theme-text-main uppercase tracking-wider flex items-
center gap-2 font-display">
<Sparkles className="w-4 h-4 text-[var(--accent-gold)]" />
<span>Lifestyle Habits & Preferences</span>
</h3>
<div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
<div>

<label className="block text-xs font-semibold theme-text-sub mb-1.5">Dietary
Preference</label>
<select
value={foodPref}
onChange={(e) => setFoodPref(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
>
<option value="Veg">Vegetarian</option>
<option value="Non-Veg">Non-Vegetarian</option>
<option value="Vegan">Vegan</option>
<option value="Jain">Jain</option>
</select>
</div>
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Sleep
Schedule</label>
<select
value={sleepSchedule}
onChange={(e) => setSleepSchedule(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
>
<option value="Early Bird">Early Bird (10 PM - 6 AM)</option>
<option value="Night Owl">Night Owl (1 AM - 8 AM)</option>
<option value="Flexible">Flexible Schedule</option>
</select>
</div>
{/* Cleanliness Slider */}
<div className="sm:col-span-2 space-y-2">
<div className="flex justify-between items-center text-xs">
<label className="font-semibold theme-text-sub">
Cleanliness Expectations Level
</label>
<span className="font-bold text-[var(--accent-gold)] font-mono-numbers flex items-center
gap-1.5">
<span>{cleanliness} / 5</span>
<div className="flex items-center gap-0.5">
{Array.from({ length: 5 }).map((_, i) => (
<Star
key={i}
className={`w-3 h-3 ${
i < cleanStarCount
? 'text-amber-400 fill-amber-400'
: 'text-slate-500/30'
}`}
/>
))}
</div>
</span>
</div>
<div className="bento-card-static p-3 flex items-center gap-3">
<input
type="range"

min="1"
max="5"
value={cleanliness}
onChange={(e) => setCleanliness(e.target.value)}
className="w-full accent-[var(--brand-accent)] cursor-pointer"
/>
</div>
</div>
<div className="sm:col-span-2">
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Smoking &
Drinking Habits</label>
<select
value={smokingDrinking}
onChange={(e) => setSmokingDrinking(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
>
<option value="Non-Smoker / Non-Drinker">Non-Smoker & Non-Drinker</option>
<option value="Non-Smoker / Social Drinker">Non-Smoker / Social Drinker</option>
<option value="Social Smoker / Social Drinker">Social Smoker & Social Drinker</option>
</select>
</div>
</div>
</div>
{/* Bento Card 4: Bio & Hobbies */}
<div className="bento-card p-6 space-y-4 transition-all duration-200 hover:-translate-y-0.5">
<h3 className="text-sm font-bold theme-text-main uppercase tracking-wider flex items-
center gap-2 font-display">
<Heart className="w-4 h-4 text-rose-500 dark:text-rose-400" />
<span>Bio & Hobbies</span>
</h3>
<div className="space-y-4">
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Hobbies & Interests
(Comma Separated)</label>
<input
type="text"
value={hobbiesInput}
onChange={(e) => setHobbiesInput(e.target.value)}
placeholder="e.g. Coding, Badminton, Reading, Gaming"
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
/>
</div>
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Bio /
Description</label>
<textarea
rows="3"
value={bio}
onChange={(e) => setBio(e.target.value)}
placeholder="Write a brief introduction about yourself..."
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"

></textarea>
</div>
</div>
</div>
</div>
</form>
</div>
);
}
Backend
import mongoose from 'mongoose';
const profileSchema = new mongoose.Schema({
userId: { type: String, required: true, index: true },
occupation: { type: String, default: 'Student / Professional' },
budget: { type: [Number], default: [10000, 25000] },
foodPref: { type: String, default: 'Veg' },
sleepSchedule: { type: String, default: 'Early Bird' },
cleanliness: { type: Number, min: 1, max: 5, default: 4 },
smokingDrinking: { type: String, default: 'Non-Smoker / Non-Drinker' },
hobbies: [{ type: String }],
preferredLocation: { type: String, default: 'Koramangala, Bangalore' },
bio: { type: String, default: 'Looking for a compatible roommate!' }
}, { timestamps: true });
export const Profile = mongoose.model('Profile', profileSchema);

Module 3 - Accommodation & Room Listing
Frontend
Property.jsx
import React, { useState, useEffect, useRef } from 'react';
import { Home, MapPin, Search, Filter, Plus, Check, Calendar, ShieldCheck, Phone, X, Eye, Users, RefreshCw,
CheckCircle2, Building, Sparkles, ShieldAlert } from 'lucide-react';
import { apiService } from '../services/api';
const DATA_PROPERTY_FALLBACK = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg'
width='400' height='250' viewBox='0 0 24 24' fill='%231f2937' stroke='%239ca3af' stroke-width='1.5'><rect
width='100%' height='100%' fill='%23374151'/><path d='m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z'/><polyline
points='9 22 9 12 15 12 15 22'/></svg>";
export default function PropertiesPage({ currentUser }) {
const [properties, setProperties] = useState([]);
const [loading, setLoading] = useState(true);
const [searchTerm, setSearchTerm] = useState('');
const [locationFilter, setLocationFilter] = useState('');
const [typeFilter, setTypeFilter] = useState('All');
const [sharingFilter, setSharingFilter] = useState('All');
const [maxBudget, setMaxBudget] = useState(30000);
const [selectedProperty, setSelectedProperty] = useState(null);
const [activeModalTab, setActiveModalTab] = useState('details'); // 'details' | 'book'
const [selectedImageIndex, setSelectedImageIndex] = useState(0);
const [bookingDate, setBookingDate] = useState(new Date().toISOString().split('T')[0]);
const [bookingTimeSlot, setBookingTimeSlot] = useState('10:00 AM - 12:00 PM');
const [bookingConfirmed, setBookingConfirmed] = useState(false);
const [bookingError, setBookingError] = useState('');
const [showAddModal, setShowAddModal] = useState(false);
// Form states for Add Property
const [newTitle, setNewTitle] = useState('');
const [newLocation, setNewLocation] = useState('');
const [newPrice, setNewPrice] = useState('');
const [newType, setNewType] = useState('Flat');
const [newSharingType, setNewSharingType] = useState('Private Room in Shared Flat');
const [newDesc, setNewDesc] = useState('');
const [newImageUrls, setNewImageUrls] = useState('');
const [selectedAmenities, setSelectedAmenities] = useState([]);
const [addPropertyError, setAddPropertyError] = useState('');
const [isSubmitting, setIsSubmitting] = useState(false);
const availableAmenities = ['WiFi', 'AC', 'Power Backup', 'Washing Machine', 'Housekeeping', 'Gym', 'Balcony',
'Biometric Lock', 'Security 24/7', '3 Meals Daily'];
const isMounted = useRef(true);
const bookingTimeoutRef = useRef(null);
useEffect(() => {
isMounted.current = true;
const fetchProperties = async () => {
try {
if (isMounted.current) setLoading(true);
const data = await apiService.getProperties().catch(() => []);
if (isMounted.current) {
setProperties(Array.isArray(data) ? data : []);
}
} catch (err) {
console.error('Failed to fetch properties:', err);
} finally {
if (isMounted.current) {
setLoading(false);
}
}
};
fetchProperties();
return () => {
isMounted.current = false;
if (bookingTimeoutRef.current) {
clearTimeout(bookingTimeoutRef.current);
}

};
}, []);
const handleImageError = (e) => {
e.target.onerror = null;
e.target.src = DATA_PROPERTY_FALLBACK;
};
const handleToggleAmenity = (amenity) => {
if ((selectedAmenities || []).includes(amenity)) {
setSelectedAmenities((selectedAmenities || []).filter(a => a !== amenity));
} else {
setSelectedAmenities([...(selectedAmenities || []), amenity]);
}
};
const hasActiveFilters = searchTerm || locationFilter || typeFilter !== 'All' || sharingFilter !== 'All' || maxBudget < 30000;
const resetFilters = () => {
setSearchTerm('');
setLocationFilter('');
setTypeFilter('All');
setSharingFilter('All');
setMaxBudget(30000);
};
const filteredProps = (properties || []).filter(p => {
if (!p) return false;
const matchesSearch = (p.title || '').toLowerCase().includes((searchTerm || '').toLowerCase()) ||
(p.location || '').toLowerCase().includes((searchTerm || '').toLowerCase()) ||
(p.description || '').toLowerCase().includes((searchTerm || '').toLowerCase());
const matchesLoc = !locationFilter || (p.location || '').toLowerCase().includes((locationFilter || '').toLowerCase());
const matchesBudget = typeof p.price === 'number' ? p.price <= maxBudget : true;
const matchesType = typeFilter === 'All' || p.type === typeFilter;
const matchesSharing = sharingFilter === 'All' || (p.sharingType &&
p.sharingType.toLowerCase().includes((sharingFilter || '').toLowerCase()));
return matchesSearch && matchesLoc && matchesBudget && matchesType && matchesSharing;});
const openPropertyModal = (prop, tab = 'details') => {
setSelectedProperty(prop);
setActiveModalTab(tab);
setSelectedImageIndex(0);
setBookingConfirmed(false);
setBookingError('');
};
const closePropertyModal = () => {
if (bookingTimeoutRef.current) {
clearTimeout(bookingTimeoutRef.current);
}
setSelectedProperty(null);
setSelectedImageIndex(0);
setBookingConfirmed(false);
setBookingError('');
setActiveModalTab('details');
};
const resetAddPropertyForm = () => {
setNewTitle('');
setNewLocation('');
setNewPrice('');
setNewType('Flat');
setNewSharingType('Private Room in Shared Flat');
setNewDesc('');
setNewImageUrls('');
setSelectedAmenities([]);
setAddPropertyError('');
};
const openAddModal = () => {
resetAddPropertyForm();
setShowAddModal(true);
};
const closeAddModal = () => {

resetAddPropertyForm();
setShowAddModal(false);
};
const handleBookVisit = async (e) => {
e.preventDefault();
setBookingError('');
if (!selectedProperty) return;
if (!bookingDate) {
setBookingError('Please select a visit date.');
return;
}
const userId = currentUser?.id || currentUser?._id || 'usr_guest';
const propId = selectedProperty.id || selectedProperty._id;
try {
await apiService.bookProperty(propId, userId, bookingDate);
if (!isMounted.current) return;
setBookingConfirmed(true);
bookingTimeoutRef.current = setTimeout(() => {
if (isMounted.current) {
closePropertyModal();
}
}, 2400);
} catch (err) {
if (!isMounted.current) return;
console.error('Failed to book property visit:', err);
setBookingError(err.response?.data?.error || err.message || 'Failed to schedule visit. Please try again.');
}
};
const handleAddPropertySubmit = async (e) => {
e.preventDefault();
setAddPropertyError('');
const trimmedTitle = (newTitle || '').trim();
const trimmedLocation = (newLocation || '').trim();
const parsedPrice = Number(newPrice);
if (!trimmedTitle) {
setAddPropertyError('Please enter a property title.');
return;
}
if (trimmedTitle.length < 3) {
setAddPropertyError('Property title must be at least 3 characters.');
return;
}
if (!trimmedLocation) {
setAddPropertyError('Please enter a location/address.');
return;
}
if (!newPrice || isNaN(parsedPrice) || parsedPrice <= 0) {
setAddPropertyError('Please enter a valid monthly rent (greater than 0).');
return;
}
const imageList = (newImageUrls || '')
.split(',')
.map(url => url.trim())
.filter(url => url.startsWith('http://') || url.startsWith('https://'));
const ownerId = currentUser?.id || currentUser?._id || '';
setIsSubmitting(true);
try {
const created = await apiService.addProperty({
title: trimmedTitle,
location: trimmedLocation,
price: parsedPrice,
type: newType,
sharingType: newSharingType,
description: (newDesc || '').trim() || 'Spacious modern co-living accommodation.',
amenities: (selectedAmenities || []).length ? selectedAmenities : ['WiFi', 'Power Backup'],

images: imageList.length ? imageList : ['https://images.unsplash.com/photo-1522708323590-
d24dbb6b0267?auto=format&fit=crop&w=800&q=80'],
ownerName: currentUser?.name || 'Property Owner',
ownerContact: currentUser?.email || '',
ownerId
});
if (!isMounted.current) return;
if (created) {
setProperties(prev => [created, ...(prev || [])]);
}
closeAddModal();
} catch (err) {
if (!isMounted.current) return;
console.error('Failed to add property listing:', err);
setAddPropertyError(err.response?.data?.error || err.message || 'Failed to publish property listing.');
} finally {
if (isMounted.current) {
setIsSubmitting(false);
}
}
};
if (loading) {
return (
<div className="max-w-7xl mx-auto py-12 px-4 flex flex-col items-center justify-center min-h-[400px]">
<Home className="w-8 h-8 text-[var(--brand-accent)] animate-spin mb-3" />
<p className="text-sm theme-text-sub font-medium">Loading property listings...</p>
</div>
);
}
return (
<div className="max-w-7xl mx-auto py-8 px-4 sm:px-6">
{/* Header Section */}
<div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mb-8">
<div>
<div className="flex items-center gap-2 mb-1">
<span className="px-2.5 py-0.5 rounded-full theme-badge-primary text-[11px] font-bold uppercase tracking-
wider">
Verified Co-Living & PGs
</span>
<span className="text-xs theme-text-muted font-mono-numbers">
{(filteredProps || []).length} Available
</span>
</div>
<h1 className="text-3xl sm:text-4xl font-extrabold theme-text-main flex items-center gap-3 font-display tracking-
tight">
Property Listings <Home className="w-7 h-7 text-[var(--brand-accent)]" />
</h1>
<p className="theme-text-sub text-sm mt-1 max-w-xl">
Explore curated, verified PGs and shared flats with zero brokerage and instant site visit scheduling.
</p>
</div>
<button
onClick={openAddModal}
className="gradient-btn px-5 py-3 text-xs sm:text-sm font-bold flex items-center gap-2 rounded-xl shadow-lg
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Plus className="w-4 h-4" />
<span>Add Property Listing</span>
</button>
</div>
{/* Clean Search & Filter Header Bar */}
<div className="bento-card-static p-4 sm:p-6 mb-8 shadow-md rounded-2xl border border-[var(--surface-border)]">
<div className="flex items-center justify-between mb-4">
<h2 className="text-sm font-bold theme-text-main flex items-center gap-2 font-display">
<Filter className="w-4 h-4 theme-text-accent" /> Search & Filter Properties

</h2>
{hasActiveFilters && (
<button
onClick={resetFilters}
className="text-xs theme-text-accent hover:underline flex items-center gap-1 font-medium transition-all
duration-200 active:scale-95"
>
<RefreshCw className="w-3 h-3" /> Reset Filters
</button>
)}
</div>
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 text-xs">
{/* Search Input */}
<div className="relative">
<Search className="w-4 h-4 theme-text-muted absolute left-3.5 top-3.5" />
<input
type="text"
placeholder="Search title, location, or area..."
value={searchTerm}
onChange={(e) => setSearchTerm(e.target.value)}
className="w-full theme-input py-2.5 pl-10 pr-3.5 text-xs outline-none rounded-xl"
/>
</div>
{/* Location Dropdown */}
<div className="relative">
<select
value={locationFilter}
onChange={(e) => setLocationFilter(e.target.value)}
className="w-full theme-input py-2.5 px-3.5 text-xs outline-none rounded-xl appearance-none cursor-pointer"
>
<option value="">All Locations</option>
<option value="Koramangala">Koramangala, Bangalore</option>
<option value="HSR Layout">HSR Layout, Bangalore</option>
<option value="Indiranagar">Indiranagar, Bangalore</option>
<option value="Whitefield">Whitefield, Bangalore</option>
<option value="BTM Layout">BTM Layout, Bangalore</option>
</select>
<MapPin className="w-3.5 h-3.5 theme-text-muted absolute right-3 top-3.5 pointer-events-none" />
</div>
{/* Property Type Filter */}
<div className="relative">
<select
value={typeFilter}
onChange={(e) => setTypeFilter(e.target.value)}
className="w-full theme-input py-2.5 px-3.5 text-xs outline-none rounded-xl appearance-none cursor-pointer"
>
<option value="All">All Property Types (PG & Flat)</option>
<option value="Flat">Shared Flat / Apartment</option>
<option value="PG">Co-Living PG</option>
</select>
<Building className="w-3.5 h-3.5 theme-text-muted absolute right-3 top-3.5 pointer-events-none" />
</div>
{/* Sharing Type Filter */}
<div className="relative">
<select
value={sharingFilter}
onChange={(e) => setSharingFilter(e.target.value)}
className="w-full theme-input py-2.5 px-3.5 text-xs outline-none rounded-xl appearance-none cursor-pointer"
>
<option value="All">All Sharing Types</option>
<option value="Private">Private Room</option>
<option value="Twin">Twin / Double Sharing</option>
<option value="Single">Single Bedroom</option>
</select>
<Users className="w-3.5 h-3.5 theme-text-muted absolute right-3 top-3.5 pointer-events-none" />

</div>
</div>
{/* Rent Slider Bar */}
<div className="mt-4 pt-4 border-t border-[var(--surface-border)] flex flex-col sm:flex-row sm:items-center justify-
between gap-3 text-xs">
<div className="flex items-center gap-3">
<span className="theme-text-sub font-semibold">Max Rent Budget:</span>
<span className="px-3 py-1 rounded-lg bento-card-static text-[var(--accent-emerald)] font-extrabold font-mono-
numbers text-sm">
₹{maxBudget.toLocaleString()} / mo
</span>
</div>
<div className="flex items-center gap-3 flex-1 max-w-md">
<span className="theme-text-muted font-mono-numbers">₹8k</span>
<input
type="range"
min="8000"
max="35000"
step="1000"
value={maxBudget}
onChange={(e) => setMaxBudget(Number(e.target.value))}
className="w-full accent-[var(--brand-accent)] cursor-pointer h-2 bento-card-static rounded-lg"
/>
<span className="theme-text-muted font-mono-numbers">₹35k</span>
</div>
</div>
</div>
{/* Properties Bento Grid */}
{(filteredProps || []).length === 0 ? (
<div className="bento-card-static p-12 text-center rounded-3xl">
<Home className="w-12 h-12 text-[var(--brand-accent)] mx-auto mb-3 opacity-50" />
<h3 className="text-lg font-bold theme-text-main font-display mb-1">No Matching Properties Found</h3>
<p className="theme-text-sub text-xs mb-4">Try adjusting your price range or clearing location filters.</p>
<button
onClick={resetFilters}
className="theme-btn-secondary px-4 py-2 text-xs font-semibold transition-all duration-200 hover:-translate-y-
0.5 active:scale-95"
>
Clear All Filters
</button>
</div>
) : (
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
{(filteredProps || []).map(prop => (
<div
key={prop?.id || prop?._id || prop?.title}
className="bento-card overflow-hidden flex flex-col justify-between group rounded-2xl border border-[var(--
surface-border)] hover:border-[var(--surface-border-accent)] transition-all duration-300 shadow-sm"
>
<div>
{/* Hero Image with Aspect Ratio */}
<div className="relative aspect-[16/10] overflow-hidden bg-[var(--surface-card)]">
<img
src={prop?.images?.[0] || 'https://images.unsplash.com/photo-1522708323590-
d24dbb6b0267?auto=format&fit=crop&w=800&q=80'}
alt={prop?.title || ''}
onError={handleImageError}
className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
/>
<div className="absolute inset-0 bg-black/30 pointer-events-none" />
{/* Overlays */}
<div className="absolute top-3 left-3 flex flex-wrap gap-1.5 items-center">

<span className="px-2.5 py-1 rounded-full glass-panel text-[11px] font-bold theme-text-accent border
border-[var(--surface-border-accent)] backdrop-blur-md">
{prop?.type || 'PG'} • {prop?.sharingType || 'Shared'}
</span>
</div>
<div className="absolute top-3 right-3">
<span className="px-2.5 py-1 rounded-full theme-badge-emerald text-[10px] font-bold flex items-center gap-
1 shadow-md">
<ShieldCheck className="w-3.5 h-3.5 text-[var(--accent-emerald)]" /> Verified
</span>
</div>
{(prop?.images || []).length > 1 && (
<span className="absolute bottom-3 right-3 px-2 py-0.5 rounded-md glass-panel text-[10px] font-mono-
numbers theme-text-main">
+{(prop.images || []).length - 1} photos
</span>
)}
</div>
{/* Card Content */}
<div className="p-5">
<div className="flex items-center gap-1 theme-text-accent text-xs font-semibold mb-1">
<MapPin className="w-3.5 h-3.5 shrink-0" />
<span className="line-clamp-1">{prop?.location || 'Location N/A'}</span>
</div>
<h3 className="text-base font-bold theme-text-main mb-2 group-hover:theme-text-accent transition-colors
line-clamp-1 font-display">
{prop?.title || 'Untitled Property'}
</h3>
<p className="text-xs theme-text-sub line-clamp-2 leading-relaxed mb-4">
{prop?.description || ''}
</p>
{/* Amenities Micro Pills */}
<div className="flex flex-wrap gap-1.5 mb-4">
{(prop?.amenities || []).slice(0, 4).map((amenity, idx) => (
<span key={idx} className="px-2.5 py-1 rounded-lg bento-card-static theme-text-sub text-[10px] font-
medium border border-[var(--surface-border)]">
{amenity}
</span>
))}
{(prop?.amenities || []).length > 4 && (
<span className="px-2 py-1 rounded-lg bento-card-static theme-text-muted text-[10px] font-mono-
numbers">
+{(prop.amenities || []).length - 4} more
</span>
)}
</div>
</div>
</div>
{/* Card Footer */}
<div className="p-5 pt-3 border-t border-[var(--surface-border)] flex items-center justify-between mt-auto bg-
[var(--surface-card)]">
<div>
<span className="text-[10px] theme-text-muted block font-bold uppercase tracking-wider">Rent</span>
<div className="flex items-baseline gap-1">
<span className="text-lg sm:text-xl font-extrabold text-[var(--accent-emerald)] font-mono-numbers">
₹{prop?.price?.toLocaleString() || '0'}
</span>
<span className="text-[10px] theme-text-muted">/mo</span>
</div>
</div>
<div className="flex items-center gap-2">
<button
onClick={() => openPropertyModal(prop, 'details')}
className="theme-btn-secondary px-3 py-2 text-xs font-semibold flex items-center gap-1 rounded-xl
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"

>
<Eye className="w-3.5 h-3.5" /> Details
</button>
<button
onClick={() => openPropertyModal(prop, 'book')}
className="gradient-btn px-3.5 py-2 text-xs font-semibold flex items-center gap-1 rounded-xl shadow-md
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Calendar className="w-3.5 h-3.5" /> Book
</button>
</div>
</div>
</div>
))}
</div>
)}
{/* Property Details & Book Visit Modal */}
{selectedProperty && (
<div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-md flex items-center justify-center p-4 overflow-y-
auto">
<div className="max-w-3xl w-full glass-panel p-6 sm:p-8 rounded-3xl border border-[var(--surface-border-accent)]
shadow-2xl relative my-8 animate-in fade-in zoom-in-95 duration-200 max-h-[90vh] overflow-y-auto">
<button
onClick={closePropertyModal}
className="absolute top-4 right-4 p-2 rounded-full bento-card-static theme-text-muted hover:theme-text-main
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<X className="w-5 h-5" />
</button>
{/* Modal Tabs Header */}
<div className="flex items-center gap-3 border-b border-[var(--surface-border)] pb-4 mb-6">
<button
onClick={() => setActiveModalTab('details')}
className={`pb-2 text-sm font-bold font-display transition-all duration-200 hover:-translate-y-0.5 active:scale-
95 relative ${
activeModalTab === 'details' ? 'theme-text-main' : 'theme-text-muted hover:theme-text-sub'
}`}
>
Property Details
{activeModalTab === 'details' && (
<span className="absolute bottom-0 left-0 right-0 h-0.5 bg-[var(--brand-accent)] rounded-full" />
)}
</button>
<button
onClick={() => setActiveModalTab('book')}
className={`pb-2 text-sm font-bold font-display transition-all duration-200 hover:-translate-y-0.5 active:scale-
95 relative flex items-center gap-1.5 ${
activeModalTab === 'book' ? 'theme-text-main' : 'theme-text-muted hover:theme-text-sub'
}`}
>
<Calendar className="w-4 h-4 text-[var(--accent-emerald)]" /> Book Site Visit
{activeModalTab === 'book' && (
<span className="absolute bottom-0 left-0 right-0 h-0.5 bg-[var(--accent-emerald)] rounded-full" />
)}
</button>
</div>
{/* Gallery Image Display */}
<div className="aspect-[16/9] rounded-2xl overflow-hidden mb-4 relative bg-[var(--surface-card)] border border-
[var(--surface-border)]">
<img
src={selectedProperty.images?.[selectedImageIndex] || selectedProperty.images?.[0] ||
'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80'}
onError={handleImageError}
className="w-full h-full object-cover"
alt={selectedProperty.title || ''}

/>
<div className="absolute bottom-3 left-3 glass-panel px-3 py-1.5 rounded-xl text-xs font-bold theme-text-main
font-mono-numbers border border-[var(--surface-border-accent)]">
₹{selectedProperty.price?.toLocaleString() || '0'} / month
</div>
<div className="absolute top-3 right-3">
<span className="px-3 py-1 rounded-full theme-badge-emerald text-xs font-bold flex items-center gap-1
shadow-md">
<ShieldCheck className="w-3.5 h-3.5 text-[var(--accent-emerald)]" /> Verified Listing
</span>
</div>
</div>
{/* Thumbnails Bar */}
{(selectedProperty.images || []).length > 1 && (
<div className="flex gap-2 mb-6 overflow-x-auto pb-2">
{(selectedProperty.images || []).map((image, idx) => (
<button
key={idx}
type="button"
onClick={() => setSelectedImageIndex(idx)}
className={`h-16 w-20 rounded-xl overflow-hidden shrink-0 border transition-all duration-200 hover:-
translate-y-0.5 active:scale-95 ${
idx === selectedImageIndex ? 'border-[var(--brand-accent)] ring-2 ring-[var(--brand-glow)]' : 'border-[var(--
surface-border)] opacity-70 hover:opacity-100'
}`}
>
<img
src={image}
alt={`Thumbnail ${idx + 1}`}
onError={handleImageError}
className="h-full w-full object-cover"
/>
</button>
))}
</div>
)}
{/* Content Tabs */}
{activeModalTab === 'details' ? (
<div className="space-y-6">
<div>
<h2 className="text-xl sm:text-2xl font-bold theme-text-main mb-1 font-display">
{selectedProperty.title || 'Untitled Property'}
</h2>
<p className="text-xs theme-text-accent flex items-center gap-1 font-medium">
<MapPin className="w-4 h-4" /> {selectedProperty.location || 'Location N/A'}
</p>
</div>
{/* Info Grid */}
<div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
<div className="bento-card-static p-3 text-xs">
<span className="theme-text-muted block text-[10px] uppercase font-bold">Property Type</span>
<span className="theme-text-main font-bold mt-0.5 block">{selectedProperty.type || 'Flat'}</span>
</div>
<div className="bento-card-static p-3 text-xs">
<span className="theme-text-muted block text-[10px] uppercase font-bold">Occupancy</span>
<span className="theme-text-main font-bold mt-0.5 block">{selectedProperty.sharingType || 'Shared
Room'}</span>
</div>
<div className="bento-card-static p-3 text-xs">
<span className="theme-text-muted block text-[10px] uppercase font-bold">Rent & Security</span>
<span className="theme-text-accent font-mono-numbers font-bold mt-0.5 block">
₹{selectedProperty.price?.toLocaleString() || '0'} / mo
</span>
</div>
</div>

{/* Description */}
<div>
<h4 className="text-xs font-bold theme-text-muted uppercase tracking-wider mb-2 font-display">
About Property
</h4>
<p className="text-xs theme-text-sub leading-relaxed bento-card-static p-4 rounded-xl">
{selectedProperty.description || 'No detailed description available.'}
</p>
</div>
{/* Amenities */}
<div>
<h4 className="text-xs font-bold theme-text-muted uppercase tracking-wider mb-2 font-display">
Included Amenities
</h4>
<div className="flex flex-wrap gap-2">
{(selectedProperty.amenities || []).map((amenity, idx) => (
<span key={idx} className="px-3 py-1.5 rounded-xl bento-card-static theme-text-main text-xs font-medium
border border-[var(--surface-border)] flex items-center gap-1.5">
<CheckCircle2 className="w-3.5 h-3.5 text-[var(--accent-emerald)]" /> {amenity}
</span>
))}
</div>
</div>
{/* Landlord Contact Box */}
<div className="p-4 rounded-2xl bento-card-static border border-[var(--surface-border-accent)] flex items-
center justify-between text-xs">
<div>
<span className="theme-text-main font-bold block text-sm">{selectedProperty.ownerName || 'Property
Owner'}</span>
<span className="theme-text-muted">Verified Property Partner</span>
</div>
{selectedProperty.ownerContact && (
<a
href={`tel:${selectedProperty.ownerContact}`}
className="flex items-center gap-2 theme-badge-emerald px-4 py-2 rounded-xl font-bold font-mono-
numbers transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Phone className="w-4 h-4" />
<span>{selectedProperty.ownerContact}</span>
</a>
)}
</div>
<div className="pt-2 flex justify-end">
<button
onClick={() => setActiveModalTab('book')}
className="gradient-btn px-6 py-3 text-xs font-bold rounded-xl flex items-center gap-2 transition-all
duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Calendar className="w-4 h-4" /> Book Site Visit Now
</button>
</div>
</div>
) : (
/* Book Visit Form Tab */
<div className="space-y-6">
<div>
<h3 className="text-lg font-bold theme-text-main font-display mb-1">
Schedule a Visit to {selectedProperty.title || 'Property'}
</h3>
<p className="theme-text-sub text-xs">
Choose your convenient date & time slot. The property manager will guide you on site.
</p>
</div>
{bookingError && (

<div className="p-3.5 rounded-xl bg-red-500/10 border border-red-500/30 text-red-600 dark:text-red-400 text-
xs font-medium flex items-center gap-2">
<ShieldAlert className="w-4 h-4 text-red-500 shrink-0" />
<span>{bookingError}</span>
</div>
)}
{bookingConfirmed ? (
<div className="p-6 rounded-2xl theme-badge-emerald text-center space-y-2 animate-in fade-in duration-
200">
<CheckCircle2 className="w-10 h-10 text-[var(--accent-emerald)] mx-auto" />
<h4 className="text-base font-bold theme-text-main font-display">Visit Scheduled Successfully!</h4>
<p className="text-xs theme-text-sub">
Your request for <span className="font-bold text-[var(--accent-emerald)]">{bookingDate}
({bookingTimeSlot})</span> has been received. {selectedProperty.ownerName || 'Property Partner'} will reach out via call
shortly.
</p>
</div>
) : (
<form onSubmit={handleBookVisit} className="bento-card-static p-6 rounded-2xl space-y-4 text-xs">
<div>
<label className="block theme-text-sub font-semibold mb-1.5">Select Visit Date</label>
<input
type="date"
min={new Date().toISOString().split('T')[0]}
value={bookingDate}
onChange={(e) => setBookingDate(e.target.value)}
className="w-full theme-input p-3 outline-none font-mono-numbers rounded-xl"
required
/>
</div>
<div>
<label className="block theme-text-sub font-semibold mb-1.5">Preferred Time Slot</label>
<div className="grid grid-cols-1 sm:grid-cols-3 gap-2">
{['10:00 AM - 12:00 PM', '02:00 PM - 04:00 PM', '05:00 PM - 07:00 PM'].map((slot) => (
<button
key={slot}
type="button"
onClick={() => setBookingTimeSlot(slot)}
className={`p-2.5 rounded-xl border text-center font-medium font-mono-numbers transition-all
duration-200 hover:-translate-y-0.5 active:scale-95 ${
bookingTimeSlot === slot ? 'theme-badge-primary border-[var(--brand-accent)]' : 'bento-card-static
theme-text-sub'
}`}
>
{slot}
</button>
))}
</div>
</div>
<div className="p-3 rounded-xl bento-card-static text-[11px] theme-text-muted flex items-start gap-2">
<Sparkles className="w-4 h-4 text-[var(--accent-gold)] shrink-0 mt-0.5" />
<span>Zero visit fees. You can reschedule or cancel visit anytime from your notifications dashboard.</span>
</div>
<button
type="submit"
className="w-full py-3.5 gradient-btn font-bold text-xs rounded-xl shadow-lg uppercase tracking-wider
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
Confirm Visit Request
</button>
</form>
)}
</div>
)}
</div>

</div>
)}
{/* Add Property Listing Modal */}
{showAddModal && (
<div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-md flex items-center justify-center p-4 overflow-y-
auto">
<div className="max-w-lg w-full glass-panel p-6 sm:p-8 rounded-3xl border border-[var(--surface-border-accent)]
shadow-2xl relative my-8 animate-in fade-in zoom-in-95 duration-200 max-h-[90vh] overflow-y-auto">
<button
onClick={closeAddModal}
className="absolute top-4 right-4 p-2 rounded-full bento-card-static theme-text-muted hover:theme-text-main
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<X className="w-5 h-5" />
</button>
<div className="mb-6">
<h3 className="text-xl font-bold theme-text-main font-display mb-1 flex items-center gap-2">
<Building className="w-5 h-5 text-[var(--brand-accent)]" /> Add New Property Listing
</h3>
<p className="text-xs theme-text-sub">List your flat or PG for verified tech professionals & students.</p>
</div>
{addPropertyError && (
<div className="mb-4 p-3.5 rounded-xl bg-red-500/10 border border-red-500/30 text-red-600 dark:text-red-400
text-xs font-medium flex items-center gap-2">
<ShieldAlert className="w-4 h-4 text-red-500 shrink-0" />
<span>{addPropertyError}</span>
</div>
)}
<form onSubmit={handleAddPropertySubmit} className="space-y-4 text-xs">
<div>
<label className="block theme-text-sub font-semibold mb-1">Property Title</label>
<input
type="text"
placeholder="e.g. Luxury 2BHK Room in Koramangala 5th Block"
value={newTitle}
onChange={(e) => setNewTitle(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl"
required
/>
</div>
<div>
<label className="block theme-text-sub font-semibold mb-1">Location / Address</label>
<input
type="text"
placeholder="e.g. HSR Layout Sector 1, Bangalore"
value={newLocation}
onChange={(e) => setNewLocation(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl"
required
/>
</div>
<div className="grid grid-cols-2 gap-3">
<div>
<label className="block theme-text-sub font-semibold mb-1">Monthly Rent (₹)</label>
<input
type="number"
min="1"
placeholder="Enter monthly rent"
value={newPrice}
onChange={(e) => setNewPrice(e.target.value)}
className="w-full theme-input p-3 outline-none font-mono-numbers rounded-xl text-[var(--accent-emerald)]
font-bold"
required
/>
</div>

<div>
<label className="block theme-text-sub font-semibold mb-1">Property Type</label>
<select
value={newType}
onChange={(e) => setNewType(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl appearance-none cursor-pointer"
>
<option value="Flat">Shared Flat</option>
<option value="PG">Co-Living PG</option>
</select>
</div>
</div>
<div>
<label className="block theme-text-sub font-semibold mb-1">Sharing / Occupancy Type</label>
<select
value={newSharingType}
onChange={(e) => setNewSharingType(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl appearance-none cursor-pointer"
>
<option value="Private Room in Shared Flat">Private Room in Shared Flat</option>
<option value="Twin Sharing Room">Twin Sharing Room</option>
<option value="Single Bedroom Apartment">Single Bedroom Apartment</option>
<option value="3BHK Master Bedroom">3BHK Master Bedroom</option>
</select>
</div>
<div>
<label className="block theme-text-sub font-semibold mb-1">Description</label>
<textarea
rows="3"
placeholder="Describe your property, house rules, nearby metro, etc."
value={newDesc}
onChange={(e) => setNewDesc(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl resize-none"
/>
</div>
{/* Amenities Selection Pills */}
<div>
<label className="block theme-text-sub font-semibold mb-1.5">Select Amenities</label>
<div className="flex flex-wrap gap-1.5">
{(availableAmenities || []).map(amenity => {
const isSelected = (selectedAmenities || []).includes(amenity);
return (
<button
key={amenity}
type="button"
onClick={() => handleToggleAmenity(amenity)}
className={`px-2.5 py-1 rounded-lg text-[11px] font-medium flex items-center gap-1 transition-all duration-
200 hover:-translate-y-0.5 active:scale-95 ${
isSelected ? 'theme-badge-primary border-[var(--brand-accent)]' : 'bento-card-static theme-text-muted
hover:theme-text-sub'
}`}
>
{isSelected ? <Check className="w-3 h-3 text-[var(--brand-accent)]" /> : <Plus className="w-3 h-3 text-
slate-400" />}
<span>{amenity}</span>
</button>
);
})}
</div>
</div>
<div>
<label className="block theme-text-sub font-semibold mb-1">Image URLs (comma separated)</label>
<input
type="text"
placeholder="https://images.unsplash.com/..., https://..."

value={newImageUrls}
onChange={(e) => setNewImageUrls(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl"
/>
</div>
<button
type="submit"
disabled={isSubmitting}
className="w-full py-3.5 gradient-btn disabled:opacity-50 font-bold text-xs rounded-xl uppercase tracking-
wider shadow-lg transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
{isSubmitting ? 'Publishing...' : 'Publish Listing'}
</button>
</form>
</div>
</div>
)}
</div>
);
}
Backend
import mongoose from 'mongoose';
const propertySchema = new mongoose.Schema({
id: { type: String, index: true },
title: { type: String, required: true },
description: { type: String },
price: { type: Number, required: true },
location: { type: String, required: true },
type: { type: String, enum: ['Flat', 'PG'], default: 'Flat' },
sharingType: { type: String, default: 'Private Room in Shared Flat' },
amenities: [{ type: String }],
images: [{ type: String }],
ownerName: { type: String, required: true },
ownerContact: { type: String, required: true },
ownerId: { type: String, index: true },
userId: { type: String, index: true },
status: { type: String, enum: ['verified', 'pending', 'rejected'], default: 'verified' }
}, { timestamps: true });
export const Property = mongoose.model('Property', propertySchema);

5.2.2 Code Efficiency
Code optimization was performed to improve the execution speed, response time, memory usage, and
overall performance of the RoomieSync application. The following techniques were used:
 Code Reusability: Common functions and components are reused instead of writing the same code
multiple times.
 Efficient Database Queries: Only the required fields and records are retrieved from MongoDB instead of
loading unnecessary data.
 Reduced Database Calls: Multiple unnecessary database requests are avoided wherever possible.
 Input Validation: User inputs are validated before processing to prevent unnecessary operations and
errors.
 Efficient Matching: The roommate compatibility calculation processes only the required profile
attributes to generate the compatibility score.
 Image Optimization: Property images uploaded by owners are handled efficiently to reduce unnecessary
storage and loading time.
 Conditional Rendering: Only the required interface components and data are displayed based on the
user’s activity.
 Error Handling: Proper error handling prevents the application from repeatedly executing failed
operations.
 Modular Code: Separate modules make the code easier to maintain, debug, and optimize.
 Avoiding Duplicate Data Processing: Data is processed only when required, reducing unnecessary
computation.
Overall, these optimization techniques help RoomieSync achieve better response time, efficient resource
utilization, maintainable code, and improved user experience.

5.3 Testing Approach
Testing Approach Testing is essential to en sure that RoomieSync functions correctly, meets all requirements,
and generates dependable outcomes. The system undergoes testing at multiple levels, beginning with
individual modules and advancing to the full application. The primary testing methodologies utilized are
Unit Testing, Integration Testing, and System Testing.
5.3.1 Unit Testing
Unit testing involves examining each module or function in isolation. Each module is assessed to verify its
expected performance. In RoomieSync, unit testing focuses on modules such as user registration, login,
profile management, compatibility score calculation, roommate requests, property management, meal
subscription, expense calculation, and agreement generation.
Examples: -
 Verifying that valid registration information successfully creates a user account.
 Ensuring that invalid login credentials are properly rejected. Confirming that the compatibility score is
calculated accurately.
 Determining if expenses are appropriately allocated among roommates.
 Verifying that property information is accurately stored.
5.3.2 Integration Testing
Integration testing occurs following the testing of individual units. It assesses whether various modules
operate correctly when integrated. In RoomieSync, integration testing evaluates the interactions between the
frontend, backend, database, and different application modules.
Examples: - User Login, User Profile, Dashboard Interface. - Roommate Matching, Request Submission,
Request Approval, Messaging. - Property Search Functionality, Property Reservation, Owner Dashboard. -
Roommate Matching, Creation of Agreements. - Expense Input, Database Interaction, Expense Overview. –
Meal Options, Subscription Service, Database Interaction.
5.3.3 System Testing
System testing evaluates the complete RoomieSync application as a unified system to ensure that all
modules work together as intended and meet the functional requirements. The entire user journey is tested,
starting from registration and profile completion to roommate matching, request acceptance, chatting,
property booking, meal subscription, agreement generation, expense management, and review submission.
Security features such as authentication and access restrictions are also tested to ensure the system is secure
and functions as expected.
Example:
 Signing up as a new user and completing profile details. Logging in and accessing the dashboard.
 Searching for and matching with suitable roommates.
 Sending and approving roommate requests.
 Accessing chat features only after a request has been accepted.
 Property owners uploading a listing with JPG/PNG images.
 Users reserving a property that is currently available.
 Creating a digital agreement for roommates. Handling shared costs.
 Transitioning between light mode and dark mode.

5.4 Modifications and Improvements
During the development of RoomieSync, s everal modifications and improvements were made to enhance the
functionality, usability, security, and overall performance of the system. The authentication module was
improved to provide secure user login and registration. A profile management module was added so that
users can enter and update their lifestyle preferences, which are used for roommate compatibility matching.
The property management module was enhanced with a separate panel for property owners, allowing them
to add property details and upload property images directly in JPG format. A chat module was incorporated
so that users can communicate after a roommate request is accepted. Meal subscription, agreement
generation, expense management, and review functionalities were also integrated to provide a complete
flatmate management system. A light and dark mode toggle was added to improve user interface
accessibility and personalization. These modifications helped make RoomieSync more convenient,
functional, and user-friendly.

